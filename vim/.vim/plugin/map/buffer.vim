""" buffer.vim

" Use Unite's quick-buffer matcher to switch buffers.
nnoremap <leader>b  :Unite buffer -quick-match<cr>

nnoremap gb :ls<cr>:buffer<space>

" Go to the next buffer.
nnoremap <leader>bn :bn<cr>

" Go to the previous buffer.
nnoremap <leader>bp :bp<cr>

" Delete this buffer
nnoremap <leader>bd :Bdelete<cr>
