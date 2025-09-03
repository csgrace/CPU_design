# a1 3bit 测试场景
# a2 8bit 输入
# a3 8bit led的输出
# a4 32bit 数码管的输出

#t3 a 00001000
#t4 b 00001004

main:
#场景选择的地址 fffffc78
li s0, 0xfffffc78
#确认键输入的地址 fffffc7c
li s1, 0xfffffc7c
#测试样例选择三位 输入的地址 fffffc74
li a1, 0xfffffc74
#高八位 输入的地址 fffffc70
li a2, 0xfffffc70
#八位led 输出的地址 fffffc60
li a3, 0xfffffc60
#a的数码管 输出的地址 fffffc64
li a4, 0xfffffc64
#b的数码管 输出的地址 fffffc68
li a5, 0xfffffc68
#a的地址 ffffec60
li a6, 0xffffec60
#b的地址 ffffec64
li a7, 0xffffec64
#浮点数a的地址 ffffec68
li s3, 0xffffec68
#浮点数b的地址 ffffec6c
li s4, 0xffffec6c


lw t1, 0(s0)
li t2, 0
beq t1, t2, scene_1
lw t1, 0(s0)
li t2, 1
beq t1, t2, scene_2
j main

scene_1:
lw t1, 0(a1)
li t2, 0
beq t1, t2, set_0
li t2, 1
beq t1, t2, set_1
li t2, 2
beq t1, t2, set_2
li t2, 3
beq t1, t2, set_3
li t2, 4
beq t1, t2, set_4
li t2, 5
beq t1, t2, set_5
li t2, 6
beq t1, t2, set_6
li t2, 7
beq t1, t2, set_7
j main

scene_2:
lw t1, 0(a1)
li t2, 0
beq t1, t2, set_8
li t2, 1
beq t1, t2, set_9
li t2, 2
beq t1, t2, set_10
li t2, 3
beq t1, t2, set_11
li t2, 4
beq t1, t2, set_12
li t2, 5
beq t1, t2, set_13
li t2, 6
beq t1, t2, set_14
li t2, 7
beq t1, t2, set_15
j main

set_0:
lw t2, 0(a2)
sw t2, 0(a3)
j end

set_1:
lb t3, 0(a2)
sw t3, 0(a4)
sw t3, 0(a6)
j end

set_2:
lbu t4, 0(a2)
sw t4, 0(a5)
sw t4, 0(a7)
j end

set_3:
lw t3, 0(a6)
lw t4, 0(a7)
beq t3, t4, led
li t2, 0
sw t2, 0(a3)
j end

set_4:
lw t3, 0(a6)
lw t4, 0(a7)
blt t3, t4, led
li t2, 0
sw t2, 0(a3)
j end

set_5:
lw t3, 0(a6)
lw t4, 0(a7)
bltu t3, t4, led
li t2, 0
sw t2, 0(a3)
j end

led:
li t2, 0x000000ff
sw t2, 0(a3)
j end

set_6:
lw t3, 0(a6)
lw t4, 0(a7)
slt t5, t3, t4
sw t5, 0(a3)
j end

set_7:
lw t3, 0(a6)
lw t4, 0(a7)
sltu t5, t3, t4
sw t5, 0(a3)
j end

set_8:  #000
lw t2, 0(a2)
li t3, 0
li t4, 0
li s1, 8

reverse_loop_8:
li t5, 7
sub t5, t5, t4
srl t6, t2, t4
andi t6, t6, 1
sll t6, t6, t5
or t3, t3, t6 
addi t4, t4, 1
blt t4, s1, reverse_loop_8

sw t3, 0(a3)
j end


set_9: #001
lw t2, 0(a2)
li t3, 0
li t4, 0
li s1, 8   

reverse_loop_9:
li t5, 7
sub t5, t5, t4
srl t6, t2, t4
andi t6, t6, 1
sll t6, t6, t5
or t3, t3, t6 
addi t4, t4, 1
blt t4, s1, reverse_loop_9

beq t2, t3, led_9
li t2, 0
sw t2, 0(a3)
j end

led_9:
li t2, 1
sw t2, 0(a3)
j end

set_10:
wait_for_confirm_a:
lw t2, 0(s1)
li t1, 0
beq t1, t2, wait_for_confirm_a 

#a
lw t3, 0(a2)
sw t3, 0(s3)

#s
srli t4, t3, 7
andi t4, t4, 1
sw t4, 0(a3)
#指数
srli t5, t3, 4
andi t5, t5, 7
#小数部分
andi t6, t3, 15
#计算整数部分
addi t6, t6, 16
sll t6, t6, t5
srli t6, t6, 7
sw t6, 0(a4)

wait_for_next:
lw t2, 0(s1)
li t1, 1
beq t1, t2, wait_for_next

wait_for_confirm_b:
lw t2, 0(s1)
li t1, 0
beq t1, t2, wait_for_confirm_b

#b
lw t3, 0(a2)
sw t3, 0(s4)

#s
srli t4, t3, 7
andi t4, t4, 1
sw t4, 0(a3)
#指数
srli t5, t3, 4
andi t5, t5, 7
#小数部分
andi t6, t3, 15
#计算整数部分
addi t6, t6, 16
sll t6, t6, t5
srli t6, t6, 7
sw t6, 0(a4)

j end

set_11:
#a
lw t3, 0(s3)
#b
lw t4, 0(s4)

#s
srli t2, t3, 7
andi t2, t2, 1
#指数
srli t5, t3, 4
andi t5, t5, 7
addi t5, t5, -3
#小数部分
andi t6, t3, 15
#计算整数部分
addi t6, t6, 16
slli t6, t6, 7
sll t6, t6, t5

addi t1, t6, 0
li s5, 0
beq t2, s5 skip_a
sub t1, s5, t6
skip_a:

#s
srli t2, t4, 7
andi t2, t2, 1
#指数
srli t5, t3, 4
andi t5, t5, 7
addi t5, t5, -3
#小数部分
andi t6, t3, 15
#计算整数部分
addi t6, t6, 16
slli t6, t6, 7
sll t6, t6, t5

li s5, 0
beq t2, s5 skip_b
sub t6, s5, t6
skip_b:

add t1, t1, t6
li t2, 0
blt t1, t2, small
srli t1, t1, 11
sw t1, 0(a4)
li t2, 0
sw t2, 0(a3)
j end

small:
li t2, 0
sub t1, t2, t1
srli t1, t1, 11
sw t1, 0(a4)
li t2, 1
sw t2, 0(a3)
j end

set_12: # 100   #校验：4bit             
    lw t0, 0(a2)              
    andi t0, t0, 0xF            # 保留最低4位

    mv s7, t0                  
    slli t0, t0, 4          

    li t1, 19           
    li t2, 0                    # i

loop:
    li t3, 7                    # data 当前最高位位置
    sub t3, t3, t2              # bit位置 = 7 - i
    srl t4, t0, t3              # 取出第 (7 - i) 位
    andi t4, t4, 1              # 取最低位

    beq t4, zero, skip_xor     

    li t5, 0                   
    sub t6, zero, t2            # -i
    addi t6, t6, 3              # 3 - i
    sll t5, t1, t6               # << (3 - i)

    xor t0, t0, t5            

skip_xor:
    addi t2, t2, 1              # i++
    li a7, 4
    blt t2, a7, loop        # if i < 4, loop

    andi t1, t0, 0xF            # CRC = 低4位
    slli s7, s7, 4             
    or t1, t1, s7              # 拼接 

    sw t1, 0(a3)               
    j end

set_13:  # 101  # 校验：8bit  
    lw t0, 0(a2)           
    mv s7, t0            

    li t1, 19         
    li t2, 0                

check_loop:
    li t3, 7
    sub t3, t3, t2        
    srl t4, t0, t3
    andi t4, t4, 1        

    beq t4, zero, skip_xor_check

    li t5, 0
    sub t6, zero, t2
    addi t6, t6, 3
    sll t5, t1, t6         
    xor t0, t0, t5      

skip_xor_check:
    addi t2, t2, 1
    li a7, 4
    blt t2, a7, check_loop

    andi t0, t0, 0xF        # 最终余数只取低4位
    beq t0, zero, pass  

fail:
    li t2, 0           
    sw t2, 0(a3)
    j end

pass:
    li t2, 1               
    sw t2, 0(a3)
    j end

set_14: #110
#    li t3,0x12345 
#    slli t3,t3,12
    lui t2, 0x12345        
    sw t2, 0(a4)
#    beq t3, t4, led_14
    j end
    
#led_14:
#li t2, 1
#sw t2, 0(a3)
#j end

set_15: #111
    lw t0, 0(a2)           
    jal ra, add_one        
    sw t0, 0(a3)          
    j end

add_one:
    addi t0, t0, 1         
    jalr zero, 0(ra)   
    
    
end:
lw t1, 0(s0)
li t3, 1
beq t1, t3, consider
j main

consider:
lw t2, 0(a1)
li t3, 2
beq t2, t3, end
j main

