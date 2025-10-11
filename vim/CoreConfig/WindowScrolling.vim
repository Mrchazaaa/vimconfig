" --- Sticky z-scroll mode -----------------------------------------------

" Variable to track scrolling mode state
let g:scrolling_mode = 0

" Function to toggle scrolling mode
function! ToggleScrollingMode()
    if g:scrolling_mode == 0
        " Enter scrolling mode
        let g:scrolling_mode = 1
        
        " Map keys to scroll viewport
        nnoremap <silent> j <C-e>
        nnoremap <silent> k <C-y>
        nnoremap <silent> h zh
        nnoremap <silent> l zl
        nnoremap <silent> <Down> <C-e>
        nnoremap <silent> <Up> <C-y>
        nnoremap <silent> <Left> zh
        nnoremap <silent> <Right> zl
        
        " Map Escape to exit scrolling mode
        nnoremap <silent> <Esc> :call ExitScrollingMode()<CR>
        
        " Display message
        echo "-- SCROLLING MODE --"
    else
        " Exit scrolling mode
        call ExitScrollingMode()
    endif
endfunction

" Function to exit scrolling mode
function! ExitScrollingMode()
    let g:scrolling_mode = 0
    
    " Restore normal mappings
    silent! nunmap j
    silent! nunmap k
    silent! nunmap h
    silent! nunmap l
    silent! nunmap <Down>
    silent! nunmap <Up>
    silent! nunmap <Left>
    silent! nunmap <Right>
    silent! nunmap <Esc>
    
    " Clear message
    echo ""
endfunction

" Map zz to toggle scrolling mode
" Note: This overrides the default zz command (center cursor in window)
nnoremap <silent> zz :call ToggleScrollingMode()<CR>
