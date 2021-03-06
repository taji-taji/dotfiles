" Vim indent file
" Language:         Shell Script
" Maintainer:       Clavelito <maromomo@hotmail.com>
" Id:               $Date: 2016-12-08 19:57:52+09 $
"                   $Revision: 4.25 $
"
" Description:      Set the following line if you do not want automatic
"                   indentation in the case labels.
"                   let g:sh_indent_case_labels = 0


if exists("b:did_indent") || !exists("g:syntax_on")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetShIndent()
setlocal indentkeys=0},0),!^F,o,O
setlocal indentkeys+=0=then,0=do,0=else,0=elif,0=fi,0=esac,0=done

if exists("*GetShIndent")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

let s:back_quote = 'shCommandSub'
let s:sh_comment = 'Comment'
let s:test_d_or_s_quote = 'TestDoubleQuote\|TestSingleQuote'
let s:d_or_s_quote = 'DoubleQuote\|SingleQuote\|DblQuote\|SnglQuote'
let s:sh_quote = 'shQuote'
let s:sh_here_doc = 'HereDoc'
let s:sh_here_doc_eof = 'HereDoc\d\d\|shRedir\d\d'

if !exists("g:sh_indent_case_labels")
  let g:sh_indent_case_labels = 1
endif

function GetShIndent()
  let lnum = prevnonblank(v:lnum - 1)
  if lnum == 0
    return 0
  endif

  if exists("b:sh_indent_tabstop")
    let &tabstop = b:sh_indent_tabstop
    unlet b:sh_indent_tabstop
  endif
  if exists("b:sh_indent_indentkeys")
    let &indentkeys = b:sh_indent_indentkeys
    unlet b:sh_indent_indentkeys
  endif

  let cline = getline(v:lnum)
  let line = getline(lnum)

  if cline =~ '^#'
    return 0
  endif

  for cid in reverse(synstack(lnum, strlen(line)))
    let cname = synIDattr(cid, 'name')
    if cname =~ s:sh_here_doc. '$'
      let lnum = s:SkipItemsLines(v:lnum, s:sh_here_doc.'\|'. s:sh_here_doc_eof)
      let ind = s:InsideHereDocIndent(lnum, cline)
      return ind
    elseif cname =~ s:test_d_or_s_quote
          \ && s:EndOfTestQuotes(line, lnum, s:test_d_or_s_quote)
      break
    elseif cname =~ s:d_or_s_quote
      return indent(v:lnum)
    endif
  endfor

  let [line, lnum] = s:SkipCommentLine(line, lnum, 0)
  let ind = 0
  for lid in reverse(synstack(lnum, 1))
    let lname = synIDattr(lid, 'name')
    if lname =~ s:sh_here_doc_eof
      let lnum = s:SkipItemsLines(lnum, s:sh_here_doc. '\|'. s:sh_here_doc_eof)
      let line = s:GetNextContinueLine(getline(lnum), lnum)
      break
    elseif lname =~ s:d_or_s_quote. '\|'. s:sh_quote
      let ind = s:BackQuoteIndent(lnum, ind)
      let line = s:HideQuoteStr(line, lnum, 1)
      let lnum = s:SkipItemsLines(lnum, s:d_or_s_quote. '\|'. s:sh_quote)
      let line = s:HideQuoteStr(getline(lnum), lnum, 0). line
      break
    endif
  endfor

  let ind = indent(lnum) + ind
  let ind = s:BackQuoteIndent(lnum, ind)
  let [pline, pnum] = s:SkipCommentLine(line, lnum, 1)
  let [pline, ind] = s:MorePrevLineIndent(pline, pnum, line, ind)
  let [line, ind] = s:InsideCaseLabelIndent(pline, line, ind)
  let ind = s:PrevLineIndent(line, lnum, pline, ind)
  let ind = s:CurrentLineIndent(line, cline, ind)

  return ind
endfunction

function s:MorePrevLineIndent(pline, pnum, line, ind)
  let ind = a:ind
  let pline = a:pline
  if s:IsContinuLine(a:pline) && s:IsContinuLine(a:line)
    let pline = s:GetPrevContinueLine(a:pline, a:pnum)
  elseif !s:IsContinuLine(a:pline) && s:IsContinuLine(a:line)
        \ && s:IsOutSideCase(a:pline)
    let ind = ind + &sw
  elseif s:IsContinuLine(a:pline) && !s:IsContinuLine(a:line)
    let pline = s:GetPrevContinueLine(a:pline, a:pnum)
    if s:IsOutSideCase(pline)
      let ind = ind - &sw
    endif
  endif

  return [pline, ind]
endfunction

function s:InsideCaseLabelIndent(pline, line, ind)
  let ind = a:ind
  let line = s:HideAnyItemLine(a:line)
  if a:line =~ ')' && a:line !~# '^\s*case\>' && s:IsInSideCase(a:pline)
    let [line, ind] = s:CaseLabelLineIndent(line, ind)
  elseif a:line =~ ';[;&]\s*$'
    let ind = ind - &sw
  elseif a:line =~ '\\$' && s:IsInSideCase(a:pline)
    let line = ""
  endif

  return [line, ind]
endfunction

function s:PrevLineIndent(line, lnum, pline, ind)
  let ind = a:ind
  if a:line =~# '^\s*\%(\%(\h\w*\|\S\+\)\s*(\s*)\s*\)\=[{(]\s*$'
        \. '\|^\s*function\s\+\S\+\%(\s\+{\|\s*(\s*)\s*[{(]\)\s*$'
    let ind = ind + &sw
  else
    let line2 = getline(a:lnum)
    let line = s:HideAnyItemLine2(a:line)
    let ind = s:ParenBraceIndent(line, ind)
    let ind = s:CloseParenIndent(line2, a:pline, line, ind)
    let ind = s:CloseBraceIndnnt(line2, line, ind)
    if line =~# '[|`(]'
      for line in split(line, '[|`(]')
        let ind = s:PrevLineIndent2(line, ind)
      endfor
    else
      let ind = s:PrevLineIndent2(line, ind)
    endif
  endif

  return ind
endfunction

function s:PrevLineIndent2(line, ind)
  let ind = a:ind
  if a:line =~# '^\s*\%(if\|then\|else\|elif\)\>'
        \ && a:line !~# '[;&]\s*\<fi\>'
        \ || a:line =~# '^\s*\%(do\|while\|until\|for\|select\)\>'
        \ && a:line !~# '[;&]\s*\<done\>'
    let ind = ind + &sw
  elseif a:line =~# '^\s*case\>'
        \ && a:line !~# ';[;&]\s*\<esac\>' && g:sh_indent_case_labels
    let ind = ind + &sw / g:sh_indent_case_labels
  endif

  return ind
endfunction

function s:CurrentLineIndent(line, cline, ind)
  let ind = a:ind
  if a:cline =~# '^\s*\%(then\|do\|else\|elif\|fi\|done\)\>[-=+.]\@!'
        \ || a:cline =~ '^\s*[})]'
    let ind = ind - &sw
  elseif a:cline =~# '^\s*esac\>' && g:sh_indent_case_labels
    let ind = ind - &sw / g:sh_indent_case_labels
  endif
  if a:cline =~# '^\s*esac\>' && a:line !~ ';[;&]\s*$'
    let ind = ind - &sw
  endif
  if ind != a:ind
        \ && a:cline =~# '^\s*\%(then\|do\|else\|elif\|fi\|done\|esac\)$'
    call s:OvrdIndentKeys(a:cline)
  endif

  return ind
endfunction

function s:CloseParenIndent(line, pline, nline, ind)
  let ind = a:ind
  if a:nline =~ ')'
        \ && a:nline !~# '^\s*case\>' && s:IsOutSideCase(a:pline)
    if a:line =~ '^\s*)'
      let ind = ind + &sw
    endif
    let ind = ind - &sw * (len(split(a:nline, ')', 1)) - 1)
  endif

  return ind
endfunction

function s:CloseBraceIndnnt(line, nline, ind)
  let ind = a:ind
  if a:nline =~# '[;&]\%(\s*\%(done\|fi\|esac\)\)\=\s*}\|^\s\+}'
    if a:line =~ '^\s*}'
      let ind = ind + &sw
    endif
    let ind = ind - &sw * (len(split(a:nline,
          \ '[;&]\%(\C\s*\%(done\|fi\|esac\)\)\=\s*}\|^\s\+}', 1)) - 1)
  endif

  return ind
endfunction

function s:ParenBraceIndent(line, ind)
  let ind = a:ind
  if a:line =~ '(\|\%(^\|&&\||\)\s*{'
    let ind = ind + &sw * (len(split(a:line, '(\|\%(^\|&&\||\)\s*{', 1)) - 1)
  endif

  return ind
endfunction

function s:SkipCommentLine(line, lnum, prev)
  let line = a:line
  let lnum = a:lnum
  if a:prev && s:GetPrevNonBlank(lnum)
    let lnum = s:prev_lnum
    let line = getline(lnum)
  elseif a:prev
    let line = ""
    let lnum = 0
  endif
  while lnum && line =~ '^\s*#' && s:GetPrevNonBlank(lnum)
        \ && synIDattr(synID(lnum, match(line,'#')+1,1),"name") =~ s:sh_comment
    let lnum = s:prev_lnum
    let line = getline(lnum)
  endwhile
  unlet! s:prev_lnum
  let line = s:HideCommentStr(line, lnum)

  return [line, lnum]
endfunction

function s:GetPrevContinueLine(line, lnum)
  let line = a:line
  let lnum = a:lnum
  let line = s:HideCommentStr(line, lnum)
  while s:IsContinuLine(line) && s:GetPrevNonBlank(lnum)
    let lnum = s:prev_lnum
    let line = getline(lnum)
    let [line, lnum] = s:SkipCommentLine(line, lnum, 0)
  endwhile
  unlet! s:prev_lnum

  return line
endfunction

function s:GetNextContinueLine(line, lnum)
  let line = a:line
  let lnum = a:lnum
  while s:IsContinuLine(line) && s:GetNextNonBlank(lnum)
    let lnum = s:next_lnum
    let line = getline(lnum)
  endwhile
  unlet! s:next_lnum

  return line
endfunction

function s:GetPrevNonBlank(lnum)
  let s:prev_lnum = prevnonblank(a:lnum - 1)

  return s:prev_lnum
endfunction

function s:GetNextNonBlank(lnum)
  let s:next_lnum = nextnonblank(a:lnum + 1)

  return s:next_lnum
endfunction

function s:CaseLabelLineIndent(line, ind)
  let line = a:line
  let ind = a:ind
  let head = ""
  let sum = 1
  let i = matchend(line, '\s*(\=')
  let sphead = i
  let slist = split(line, '\zs')
  let max = len(slist)
  while sum && i < max
    if slist[i] == '('
      let sum += 1
    elseif slist[i] == ')'
      let sum -= 1
    endif
    let head .= slist[i]
    let i += 1
  endwhile
  if sum == 0
    let line = strpart(line, strlen(head) + sphead)
    let ind = ind + &sw
  endif
  if line =~ ';[;&]\s*$'
    let ind = ind - &sw
  endif

  return [line, ind]
endfunction

function s:HideAnyItemLine(line)
  let line = a:line
  if line =~ '[|&`(){}]'
    if line =~ '\\.'
      let line = substitute(line,
            \ '\\\@<!\%(\\\\\)*\\[;,\\[:blank:]|&`(){}"'. "']", '', 'g')
    endif
    if line =~ '"\|\%o47\|`'
      let line = substitute(line, '\("\|\%o47\|`\).\{-}\1', '', 'g')
    endif
  endif

  return line
endfunction

function s:HideAnyItemLine2(line)
  let line = a:line
  if line =~ '[()]'
    let len = 0
    while len != strlen(line)
      let len = strlen(line)
      let line = substitute(line, '[$=]\=([^()]*)', '', 'g')
    endwhile
  endif
  if line =~ '^\s*{\%(\s*$\)\@!'
    let line = substitute(line,
          \ '\$\@<!{\%([^},[:blank:]]\{-},\)\+[^},[:blank:]]\{-}}', '', 'g')
  endif

  return line
endfunction

function s:GetTabAndSpaceSum(cline, cind, sstr, sind)
  if a:cline =~ '^\t'
    let tbind = matchend(a:cline, '\t*', 0)
  else
    let tbind = 0
  endif
  let spind = a:cind - tbind * &tabstop
  if a:sstr =~ '<<-' && a:sind
    let tbind = a:sind / &tabstop
  endif

  return [tbind, spind]
endfunction

function s:InsideHereDocIndent(snum, cline)
  let sstr = getline(a:snum)
  if !&expandtab && sstr =~ '<<-' && !strlen(a:cline)
    let ind = indent(a:snum)
  else
    let ind = indent(v:lnum)
  endif
  if !&expandtab && a:cline =~ '^\t'
    let sind = indent(a:snum)
    let [tbind, spind] = s:GetTabAndSpaceSum(a:cline, ind, sstr, sind)
    if spind >= &tabstop
      let b:sh_indent_tabstop = &tabstop
      let &tabstop = spind + 1
    endif
    let ind = tbind * &tabstop + spind
  elseif &expandtab && a:cline =~ '^\t' && sstr =~ '<<-'
    let tbind = matchend(a:cline, '\t*', 0)
    let ind = ind - tbind * &tabstop
  endif

  return ind
endfunction

function s:SkipItemsLines(lnum, item)
  let lnum = a:lnum
  while lnum
    let sum = 0
    for lid in synstack(lnum, 1)
      if synIDattr(lid, 'name') =~ a:item
        let sum = 1
        break
      endif
    endfor
    if sum && s:GetPrevNonBlank(lnum)
      let lnum = s:prev_lnum
      unlet! s:prev_lnum
    else
      unlet! s:prev_lnum
      break
    endif
  endwhile

  return lnum
endfunction

function s:HideCommentStr(line, lnum)
  let line = a:line
  if a:lnum && line =~ '\%(\${\%(\h\w*\|\d\+\)#\=\|\${\=\)\@<!#'
    let sum = match(line, '#', 0)
    while sum > -1
      if synIDattr(synID(a:lnum, sum + 1, 1), "name") =~ s:sh_comment
        let line = strpart(line, 0, sum)
        break
      endif
      let sum = match(line, '#', sum + 1)
    endwhile
  endif

  return line
endfunction

function s:HideQuoteStr(line, lnum, rev)
  let line = a:line
  let sum = match(a:line, '\%o47\|"', 0)
  while sum > -1
    let n = 0
    for cid in reverse(synstack(a:lnum, sum + 1))
      let cname = synIDattr(cid, 'name')
      if !n && cname =~ s:sh_quote && a:rev
        let line = strpart(a:line, sum + 1)
        let n += 1
      elseif !n && cname =~ s:sh_quote
        let n += 1
      elseif n && cname =~ s:d_or_s_quote
        let line = strpart(a:line, 0, sum)
        break
      else
        break
      endif
    endfor
    if n && !a:rev
      break
    endif
    let sum = match(a:line, '\%o47\|"', sum + 1)
  endwhile

  return line
endfunction

function s:BackQuoteIndent(lnum, ind)
  let line = getline(a:lnum)
  let ind = a:ind
  let lsum = -1
  if line =~ '\\\@<!\%(\\\\\)*`'
    let sum = match(line, '\\\@<!\%(\\\\\)*\zs`', 0)
    while sum > -1
      let esum = sum + 1
      if synIDattr(synID(a:lnum, esum, 1), "name") =~ s:back_quote
        let sum2 = 0
        if sum
          for cid in synstack(a:lnum, sum)
            if synIDattr(cid, 'name') =~ s:back_quote
              let sum2 += 1
            endif
          endfor
        endif
        if !sum2 || sum2 && sum == lsum
          let ind += &sw
        elseif sum2
          let ind -= &sw
        endif
        let lsum = esum
      endif
      let sum = match(line, '\\\@<!\%(\\\\\)*\zs`', esum)
    endwhile
  endif

  return ind
endfunction

function s:OvrdIndentKeys(line)
  let b:sh_indent_indentkeys = &indentkeys
  setlocal indentkeys+=a,b,c,d,<e>,f,g,h,i,j,k,l,m,n,<o>,p,q,r,s,t,u,v,w,x,y,z
  setlocal indentkeys+=A,B,C,D,E,F,G,H,I,J,K,L,M,N,<O>,P,Q,R,S,T,U,V,W,X,Y,Z
  setlocal indentkeys+=1,2,3,4,5,6,7,8,9,<0>,_,-,=,+,.
  if a:line =~# '^\s*do$'
    setlocal indentkeys-=n
    setlocal indentkeys+=<Space>,*<CR>
  endif
endfunction

function s:IsContinuLine(line)
  return a:line =~# '\\\@<!\%(\\\\\)*\%(\\$\|\%(&&\|||\)\s*$\)'
endfunction

function s:IsOutSideCase(line)
  return a:line !~# '\%(^\|[|&`()]\)\s*case\>\%(.*;[;&]\s*\<esac\>\)\@!'
        \ && a:line !~# ';[;&]\s*$'
endfunction

function s:IsInSideCase(line)
  return a:line =~# '\%(^\|[|&`()]\)\s*case\>\%(.*;[;&]\s*\<esac\>\)\@!'
        \ || a:line =~# ';[;&]\s*$'
endfunction

function s:EndOfTestQuotes(line, lnum, item)
  return a:line =~ '^\%("\|\%o47\)$'
        \ || a:line =~ '\\\@<!\%(\\\\\)*\%("\|\%o47\)$'
        \ && synIDattr(synID(a:lnum, strlen(a:line) - 1, 1), "name") =~ a:item
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: set sts=2 sw=2 expandtab:
