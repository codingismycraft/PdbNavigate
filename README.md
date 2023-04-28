# PdbNavigate
A vim plugin to make python debugging using pdb simpler.

## To start your vim session

```
vim --servername VIM
```

## You need to start pdb in separate terminal


## To Add a break point from vim

```
<CTRL - F8>
```

## To Clear all breakpoints

```
<CTRL - F7>
```

## Using it from SSH

Make sure that you start the ssh session as follows:

```
ssh -X <name>
```

## To enable cross machine clipboard

You might need to install and run xclip

## vim requirements

version 8.1 +
compiled with 
+ clipboard and +X11

If cliboard is missing you can try:

```
sudo apt install vim-gtk3
```

