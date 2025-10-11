let s:config_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

function! RelativeSource(relpath) abort
  execute 'source' s:config_dir . a:relpath
endfunction

call RelativeSource('/CoreConfig/Main.vim')

