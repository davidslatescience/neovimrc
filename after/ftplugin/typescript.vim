" Vim filetype plugin file
" Language:	TypeScript
" Maintainer:	Doug Kearns <dougkearns@gmail.com>
" Last Change:	2019 Aug 30


" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Set 'comments' to format dashed lists in comments.
"setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/**,mb:*,ex:*/,://
" setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
" setlocal comments=s1:/**,mb:*,ex:*/

" setlocal commentstring=//%s

