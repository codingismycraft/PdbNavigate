python3 << endpython
def PaintLineAsActiveInDebuger(linenum):
    command = f'matchaddpos("Debug", {linenum})'
    vim.eval(command)

def GetLineNumber(s):
    import re
    regex_pattern = r"break\s.*\.py:(\d+)"
    match = re.search(regex_pattern, s)
    if match:
        return int(match.group(1))
    else:
        raise ValueError

def GetFilename(s):
    s = s.strip()
    if not s.startswith('break'):
        raise ValueError
    import re
    regex_pattern = r'break\s+([\S\/]+\.\w+):\d'
    match = re.search(regex_pattern, s)
    if match:
        return match.group(1)
    else:
        raise ValueError

def PaintDebugLines(home_dir, filename):
    import os
    import vim
    current_linenum = int(vim.eval("""line(".")"""))
    vim.eval("""clearmatches()""")
    filename = filename.strip()
    line_numbers = []
    pdbrc_filepath= os.path.join(home_dir, ".pdbrc")
    try:
        with open(pdbrc_filepath) as fin:
            for line in fin:
                line = line.strip()
                try:
                    file = GetFilename(line)
                    if file.strip() != filename:
                        continue
                    line_numbers.append(GetLineNumber(line))
                except ValueError:
                    pass
    except FileNotFoundError:
        pass

    x = line_numbers
    y, x = x[:8], x[8:]

    while y:
        command = f'matchaddpos("Debug", {y})'
        vim.eval(command)
        y, x = x[:8], x[8:]
        



def ClearAllDebugDataPoints(home_dir, fullpath):
    """Clears all debug data points by removing the .pdbrc.

    If the .pdbrc file does not exit then it will be created and the 
    default aliases needed from pdb will also be added to it.  

    If the .pdbrc already exist then all the break points, meaning lines
    that start with the 'break' token will be removed. 

    Args:
        home_dir (str): The path to the home directory where the .pdbrc file is
        located.
    """   
    import os
    pdbrc_filepath= os.path.join(home_dir, ".pdbrc")
    if not os.path.isfile(pdbrc_filepath):
        alias_ = (
                f'alias bs with open("{pdbrc_filepath}", "a") as pdbrc: ' 
                'pdbrc.write("break " + __file__ + ":%1\\n")\n'
        )
        with open(pdbrc_filepath, "w") as fout:
            fout.write(alias_)
    else:
        lines = []
        with open(pdbrc_filepath) as fin:
            for line in fin:
                line = line.strip()
                if not line.startswith("break "):
                    lines.append(line)
        with open(pdbrc_filepath, "w") as fout:
            for line in lines:
                fout.write(f"{line}\n")
                
    PaintDebugLines(home_dir, fullpath)


def UpdateDebugBreakpoints(home_dir, fullpath, linenum):
    """Update breakpoints in .pdbrc file.

    If the .pdbrc file does not exist it will be created.

    The .pdbrc file is a user-specific configuration file used by the
    Python debugger (PDB) to store settings and commands that are executed
    automatically when the debugger starts.
    
    If the corresponding to the fullpath and the linenum already exists
    it the .pdbrc file then it will be removed otherwise it will be added.

    Parameters:
    - home_dir (str): The home directory path where the .pdbrc file is
      located.
    - fullpath (str): The full path of the file for which the breakpoint
      needs to be added or removed.
    - linenum (int): The line number of the breakpoint.

    Returns: None
    """
    import os

    pdbrc_filepath= os.path.join(home_dir, ".pdbrc")
    lines = []

    try:
        with open(pdbrc_filepath) as fin:
            for line in fin:
                lines.append(line.strip())
    except FileNotFoundError:
        pass

   
    line_to_add = f'break {fullpath}:{linenum}'

    if line_to_add in lines:
        lines.remove(line_to_add)
    else:
        lines.append(line_to_add)


    with open(pdbrc_filepath, "w") as fout:
        for line in lines:
            fout.write(f"{line}\n")
    
    PaintDebugLines(home_dir, fullpath)
endpython


  
function! pdbnavigate#AddToDebug()
let n = line(".")
python3 << endpython
import vim
home_dir = vim.eval("""expand("$HOME")""")
fullpath = vim.eval("""expand("%:p")""")
linenum = int(vim.eval("""line(".")"""))
UpdateDebugBreakpoints(home_dir, fullpath, linenum)
endpython
execute ":".n 
endfunction

function! pdbnavigate#ClearDebug()
let n = line(".")
python3 << endpython
import vim
home_dir = vim.eval("""expand("$HOME")""")
fullpath = vim.eval("""expand("%:p")""")
ClearAllDebugDataPoints(home_dir, fullpath)
endpython
execute ":".n
endfunction

function! pdbnavigate#ActivateWindow(filepath)
    " If the passed in file path is already open then the corresponding window 
    " will be activated. 
    " Othewise the file will be opened in the active window (overwritting the
    " existing content).
    let windowNr = bufwinnr(a:filepath)
    if windowNr > 0
        execute windowNr 'wincmd w'
    else
        execute "edit". a:filepath
    endif  
endfunction

function! pdbnavigate#MoveToLine(filepath, linenum)
" Activates the file and moves the cursor to the pass in line.
call pdbnavigate#ActivateWindow(a:filepath)
call cursor(a:linenum, 1)
execute "hi CursorLine ctermbg=blue"
python3 << endpython
import vim
filepath = vim.eval("a:filepath")
linenum = int(vim.eval("a:linenum"))
endpython
endfunction

function! pdbnavigate#ListBuffers()
    " Prints the names of all the buffers.
    let buffers = getbufinfo()                                                                                                                                                                              
    for b in buffers
        echo b.name b.windows
    endfor 
endfunction

function! pdbnavigate#ActivateWindow(filepath)
    " If the passed in file path is already open then the corresponding window 
    " will be activated. 
    " Othewise the file will be opened in the active window (overwritting the
    " existing content).
    execute "highlight CursorLine NONE"
    let windowNr = bufwinnr(a:filepath)
    if windowNr > 0
        execute windowNr 'wincmd w'
    else
        execute "edit ". a:filepath
    endif  
endfunction

function! pdbnavigate#PaintActiveLine(linenum)
python3 << endpython
import vim
PaintLineAsActiveInDebuger(linenum)
endpython
endfunction

function! pdbnavigate#ResetCursor()
    execute "highlight CursorLine NONE"
endfunction

function! pdbnavigate#OnOpenDocument()
" When a document is opened it paints its breakpoints.
python3 << endpython
import vim
home_dir = vim.eval("""expand("$HOME")""")
fullpath = vim.eval("""expand("%:p")""")
PaintDebugLines(home_dir, fullpath)
endpython
endfunction

