syntax enable
set number
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" Add plugins here which you want to add
Plugin 'tomasiser/vim-code-dark'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'jvirtanen/vim-hcl'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'ycm-core/YouCompleteMe'
call vundle#end()

filetype plugin indent on
colorscheme codedark
autocmd BufNewFile,BufRead Vagrantfile set syntax=ruby
set list
set listchars=tab:>-
set expandtab
set autoindent
set tabstop=4
set mouse=a
set hlsearch
autocmd BufNewFile,BufRead Jenkinsfile set syntax=groovy
