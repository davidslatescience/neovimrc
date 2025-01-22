packadd cfilter

" When using `dd` in the quickfix list, remove the item from the quickfix list.
nnoremap <buffer> <silent> dd
  \ <Cmd>call setqflist(filter(getqflist(), {idx -> idx != line('.') - 1}), 'r') <Bar> cc<CR>:copen<CR>



