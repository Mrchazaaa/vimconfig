command! MessagesToBuf
      \ redir => m |
      \ silent messages |
      \ redir END |
      \ new |
      \ put =m
 
