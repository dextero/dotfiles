source ~/.gdb/gdb-dashboard/.gdbinit
#set disassembly-flavor intel
source /home/marcin/scripts/gdb/offset_of.py
source /home/marcin/scripts/gdb/stack-used.py
#source /home/marcin/scripts/gdb/colored_display.py
#colored-display output file
dashboard source -style context 20
dashboard expressions
dashboard assembly
dashboard threads
dashboard memory
source /home/marcin/projects/avs_commons/gdb/print-avs-list.py
source /home/marcin/projects/avs_commons/gdb/print-avs-rbtree.py
