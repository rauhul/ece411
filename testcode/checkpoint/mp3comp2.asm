; Arguments:
;   R0: Number of bytes to checksum
;   R1: Starting address
codes0:
    lea r5, datas0
    ldr r6, r5, stack_bottom

    str r0, r5, input_len
    str r1, r5, input_ptr
    br start

segment 32
datas0:

stack_bottom:
    data2 4xE000

c56:
    data2 56
c64:
    data2 64
cx80:
    data2 4x0080
cx003f:
    data2 4x003f

memcpy_ptr0:
    data2 memcpy

message_ptr0:
    data2 message

message_len_ptr0:
    data2 message_len

digest:
    struct md5digest ?

digest_save:
    data4[4] ?

input_len:
    data4 input$len

input_ptr:
    data2 input

input:
    ;data1[] "abc"
    ;data1[] "the quick brown fox jumps over the lazy dog the quick brown fox jumps over the lazy dog"
    data1[] "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque id molestie leo, nec rutrum dui. Curabitur nunc eros, aliquam ac libero sit amet, euismod faucibus est. Proin gravida scelerisque amet."

segment 352
codes1:

start:
    ldr r0, r5, input_len
    ldr r1, r5, c56
    ldr r2, r5, cx003f
    and r2, r2, r0
    not r2, r2
    add r2, r2, 1
    add r2, r2, r1
    brp lt_56
    ldr r1, r5, c64
    add r2, r2, r1

lt_56:
    add r3, r0, r2
    add r3, r3, 8
    sti r3, r5, message_len_ptr0
    ldr r3, r5, input_ptr
    ldr r4, r5, message_ptr0
    add r6, r6, -6
    str r0, r6, 0
    str r4, r6, 1
    str r3, r6, 2
    ldr r1, r5, memcpy_ptr0
    jsrr r1
    add r2, r2, -1
    and r1, r1, 0
    add r1, r1, 1
    lshf r1, r1, 7
    add r4, r4, r0
    stb r1, r4, 0
    and r3, r3, 0

zero_loop:
    add r2, r2, -1
    brn append_length
    add r4, r4, 1
    stb r3, r4, 0
    br zero_loop

append_length:
    lshf r0, r0, 3
    add r4, r4, 1
    str r0, r4, 0
    str r3, r4, 1
    str r3, r4, 2
    str r3, r4, 3
    br md5_blocks

segment
datas1:

message_ptr1:
    data2 message

digest_ptr:
    data2 digest

digest_save_ptr:
    data2 digest_save

s_table_ptr:
    data2 s_table

m_table_ptr:
    data2 m_table

k_table_ptr:
    data2 k_table

func_ptrs:
    data2 md5_ffunc
    data2 md5_gfunc
    data2 md5_hfunc
    data2 md5_ifunc

add32_ptr:
    data2 add32

left_rotate32_ptr:
    data2 left_rotate32

memcpy_ptr1:
    data2 memcpy

cn64:
    data2 -64

digest_len:
    data2 16

message_len_ptr1:
    data2 message_len

s_table:
    data1[64]  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,
               5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,
               4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,
               6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21

m_table:
    data1[64]  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
               1,  6, 11,  0,  5, 10, 15,  4,  9, 14,  3,  8, 13,  2,  7, 12,
               5,  8, 11, 14,  1,  4,  7, 10, 13,  0,  3,  6,  9, 12, 15,  2,
               0,  7, 14,  5, 12,  3, 10,  1,  8, 15,  6, 13,  4, 11,  2,  9

k_table:
    data4[64] 4xd76aa478, 4xe8c7b756, 4x242070db, 4xc1bdceee,
              4xf57c0faf, 4x4787c62a, 4xa8304613, 4xfd469501,
              4x698098d8, 4x8b44f7af, 4xffff5bb1, 4x895cd7be,
              4x6b901122, 4xfd987193, 4xa679438e, 4x49b40821,
              4xf61e2562, 4xc040b340, 4x265e5a51, 4xe9b6c7aa,
              4xd62f105d, 4x02441453, 4xd8a1e681, 4xe7d3fbc8,
              4x21e1cde6, 4xc33707d6, 4xf4d50d87, 4x455a14ed,
              4xa9e3e905, 4xfcefa3f8, 4x676f02d9, 4x8d2a4c8a,
              4xfffa3942, 4x8771f681, 4x6d9d6122, 4xfde5380c,
              4xa4beea44, 4x4bdecfa9, 4xf6bb4b60, 4xbebfbc70,
              4x289b7ec6, 4xeaa127fa, 4xd4ef3085, 4x04881d05,
              4xd9d4d039, 4xe6db99e5, 4x1fa27cf8, 4xc4ac5665,
              4xf4292244, 4x432aff97, 4xab9423a7, 4xfc93a039,
              4x655b59c3, 4x8f0ccc92, 4xffeff47d, 4x85845dd1,
              4x6fa87e4f, 4xfe2ce6e0, 4xa3014314, 4x4e0811a1,
              4xf7537e82, 4xbd3af235, 4x2ad7d2bb, 4xeb86d391

segment
codes2:
md5_blocks:
    lea r5, datas1
    add r6, r6, -2
    str r5, r6, 0
    add r6, r6, -2

md5_block_loop:
    and r3, r3, 0
    str r3, r6, 0
    ldr r0, r5, digest_len
    ldr r1, r5, digest_save_ptr
    ldr r2, r5, digest_ptr
    add r6, r6, -6
    str r0, r6, 0
    str r1, r6, 1
    str r2, r6, 2
    ldr r2, r5, memcpy_ptr1
    jsrr r2

md5_rounds_loop:
    ldr r3, r6, 0
    and r1, r1, 0
    add r1, r1, -1
    lshf r1, r1, 6
    and r1, r1, r3
    brnp md5_rounds_loop_done
    add r1, r3, 1
    str r1, r6, 0
    rshfl r1, r3, 3
    and r1, r1, 1x00110
    add r2, r5, r1
    ldr r7, r2, func_ptrs
    and r0, r3, 1x00011
    not r0, r0
    add r4, r0, 5
    and r2, r4, 1x00011
    lshf r2, r2, 2
    ldr r1, r5, digest_ptr
    add r0, r1, r2
    add r1, r0, 2
    ldr r0, r0, 0
    ldr r1, r1, 0
    add r6, r6, -4
    str r0, r6, 0
    str r1, r6, 1
    add r0, r4, -3
    add r1, r4, -2
    add r2, r4, -1
    and r0, r0, 1x00011
    and r1, r1, 1x00011
    lshf r0, r0, 2
    lshf r1, r1, 2
    lshf r2, r2, 2
    ldr r4, r5, digest_ptr
    add r0, r0, r4
    add r1, r1, r4
    add r2, r2, r4
    add r6, r6, -6
    str r0, r6, 0
    str r1, r6, 1
    str r2, r6, 2
    add r4, r7, 0
    jsrr r4
    ldr r4, r5, add32_ptr
    jsrr r4
    lshf r2, r3, 2
    ldr r4, r5, k_table_ptr
    add r4, r4, r2
    ldr r0, r4, 0
    ldr r1, r4, 1
    add r6, r6, -4
    str r0, r6, 0
    str r1, r6, 1
    ldr r4, r5, add32_ptr
    jsrr r4
    ldr r4, r5, m_table_ptr
    add r4, r4, r3
    ldb r2, r4, 0
    lshf r2, r2, 2
    ldr r4, r5, message_ptr1
    add r4, r4, r2
    ldr r0, r4, 0
    ldr r1, r4, 1
    add r6, r6, -4
    str r0, r6, 0
    str r1, r6, 1
    ldr r4, r5, add32_ptr
    jsrr r4
    ldr r4, r5, s_table_ptr
    add r0, r4, r3
    ldb r0, r0, 0
    add r1, r0, -16
    brnz shift_cont

shift_swap_words:
    ldr r2, r6, 0
    ldr r4, r6, 1
    str r2, r6, 1
    str r4, r6, 0
    add r0, r1, 0

shift_cont:
    add r6, r6, -2
    str r0, r6, 0
    ldr r4, r5, left_rotate32_ptr
    jsrr r4
    and r0, r3, 1x00011
    not r0, r0
    add r4, r0, 2
    and r2, r4, 1x00011
    lshf r2, r2, 2
    ldr r1, r5, digest_ptr
    add r1, r1, r2
    ldr r0, r1, 0
    ldr r1, r1, 1
    add r6, r6, -4
    str r0, r6, 0
    str r1, r6, 1
    ldr r2, r5, add32_ptr
    jsrr r2
    add r2, r4, 3
    and r2, r2, 1x00011
    lshf r2, r2, 2
    ldr r1, r5, digest_ptr
    add r2, r2, r1
    ldr r0, r6, 0
    ldr r1, r6, 1
    add r6, r6, 4
    str r0, r2, 0
    str r1, r2, 1
    br md5_rounds_loop

md5_rounds_loop_done:
    and r3, r3, 0
    add r3, r3, 4
    ldr r2, r5, digest_ptr
    ldr r4, r5, digest_save_ptr

accumulate_digest_loop:
    add r3, r3, -1
    brn accumulate_digest_done
    add r6, r6, -8
    ldr r0, r4, 0
    str r0, r6, 0
    ldr r1, r4, 1
    str r1, r6, 1
    ldr r0, r2, 0
    str r0, r6, 2
    ldr r1, r2, 1
    str r1, r6, 3
    ldr r0, r5, add32_ptr
    jsrr r0
    ldr r0, r6, 0
    ldr r1, r6, 1
    add r6, r6, 4
    str r0, r2, 0
    str r1, r2, 1
    add r2, r2, 4
    add r4, r4, 4
    br accumulate_digest_loop

accumulate_digest_done:
    ldi r0, r5, message_len_ptr1
    ldr r1, r5, cn64
    add r0, r0, r1
    brz finish
    sti r0, r5, message_len_ptr1
    ldr r0, r5, message_ptr1
    not r1, r1
    add r1, r1, 1
    add r0, r0, r1
    str r0, r5, message_ptr1
    br md5_block_loop

finish:
    ldr r7, r5, digest_ptr
    ldb r4, r7, 14
    lshf r4, r4, 8
    ldb r5, r7, 15
    add r0, r4, r5
    lea r1, last_word
    str r0, r1, 0
    ldb r4, r7, 0
    lshf r4, r4, 8
    ldb r5, r7, 1
    add r0, r4, r5
    ldb r4, r7, 2
    lshf r4, r4, 8
    ldb r5, r7, 3
    add r1, r4, r5
    ldb r4, r7, 4
    lshf r4, r4, 8
    ldb r5, r7, 5
    add r2, r4, r5
    ldb r4, r7, 6
    lshf r4, r4, 8
    ldb r5, r7, 7
    add r3, r4, r5
    ldb r4, r7, 8
    lshf r4, r4, 8
    ldb r5, r7, 9
    add r4, r4, r5
    ldb r5, r7, 10
    lshf r5, r5, 8
    ldb r6, r7, 11
    add r5, r5, r6
    ldb r6, r7, 12
    lshf r6, r6, 8
    ldb r7, r7, 13
    add r6, r6, r7
    lea r7, last_word
    ldr r7, r7, 0
    br halt

last_word:
    data2 ?

halt:
    br halt

structdef md5digest
    a:  data4 4x67452301
    b:  data4 4xefcdab89
    c:  data4 4x98badcfe
    d:  data4 4x10325476
end

add32:
    add r6, r6, -8
    str r0, r6, 0
    str r1, r6, 1
    str r2, r6, 2
    str r3, r6, 3
    ldr r0, r6, 4
    ldr r1, r6, 6
    and r2, r0, 1x01
    and r3, r1, 1x01
    add r2, r2, r3
    and r3, r2, 1x01
    rshfl r0, r0, 1
    rshfl r1, r1, 1
    rshfl r2, r2, 1
    add r0, r0, r2
    add r0, r0, r1
    rshfl r2, r0, 15
    lshf r0, r0, 1
    add r3, r3, r0
    ldr r0, r6, 5
    ldr r1, r6, 7
    add r2, r2, r0
    add r2, r2, r1
    str r3, r6, 6
    str r2, r6, 7
    ldr r0, r6, 0
    ldr r1, r6, 1
    ldr r2, r6, 2
    ldr r3, r6, 3
    add r6, r6, 12
    ret

left_rotate32:
    add r6, r6, -12
    str r0, r6, 0
    str r1, r6, 1
    str r2, r6, 2
    str r3, r6, 3
    str r4, r6, 4
    str r5, r6, 5
    ldr r0, r6, 7
    ldr r1, r6, 8
    add r2, r0, 0
    add r3, r1, 0
    ldr r4, r6, 6

left_rotate32_ls16:
    add r5, r4, -16
    brn left_rotate32_ls8
    and r2, r2, 0
    and r3, r3, 0
    br left_rotate32_ls_done

left_rotate32_ls8:
    add r5, r4, -8
    brn left_rotate32_ls4
    lshf r2, r2, 8
    lshf r3, r3, 8
    add r4, r5, 0

left_rotate32_ls4:
    add r5, r4, -4
    brn left_rotate32_ls2
    lshf r2, r2, 4
    lshf r3, r3, 4
    add r4, r5, 0

left_rotate32_ls2:
    add r5, r4, -2
    brn left_rotate32_ls1
    lshf r2, r2, 2
    lshf r3, r3, 2
    add r4, r5, 0

left_rotate32_ls1:
    add r5, r4, -1
    brn left_rotate32_ls_done
    lshf r2, r2, 1
    lshf r3, r3, 1

left_rotate32_ls_done:
    ldr r4, r6, 6
    not r4, r4
    add r4, r4, 2
    add r4, r4, 15

left_rotate32_rs16:
    add r5, r4, -16
    brn left_rotate32_rs8
    and r2, r2, 0
    and r3, r3, 0
    br left_rotate32_rs_done

left_rotate32_rs8:
    add r5, r4, -8
    brn left_rotate32_rs4
    rshfl r0, r0, 8
    rshfl r1, r1, 8
    add r4, r5, 0

left_rotate32_rs4:
    add r5, r4, -4
    brn left_rotate32_rs2
    rshfl r0, r0, 4
    rshfl r1, r1, 4
    add r4, r5, 0

left_rotate32_rs2:
    add r5, r4, -2
    brn left_rotate32_rs1
    rshfl r0, r0, 2
    rshfl r1, r1, 2
    add r4, r5, 0

left_rotate32_rs1:
    add r5, r4, -1
    brn left_rotate32_rs_done
    rshfl r0, r0, 1
    rshfl r1, r1, 1

left_rotate32_rs_done:
    add r2, r2, r1
    add r3, r3, r0
    str r2, r6, 7
    str r3, r6, 8
    ldr r0, r6, 0
    ldr r1, r6, 1
    ldr r2, r6, 2
    ldr r3, r6, 3
    ldr r4, r6, 4
    ldr r5, r6, 5
    add r6, r6, 14
    ret

md5_ffunc:
    add r6, r6, -10
    str r0, r6, 0
    str r1, r6, 1
    str r2, r6, 2
    str r3, r6, 3
    str r4, r6, 4
    ldi r0, r6, 5
    ldi r1, r6, 6
    ldi r2, r6, 7
    and r1, r1, r0
    not r0, r0
    and r2, r2, r0
    add r0, r1, r2
    ldr r2, r6, 5
    ldr r3, r6, 6
    ldr r4, r6, 7
    add r2, r2, 2
    add r3, r3, 2
    add r4, r4, 2
    str r2, r6, 5
    str r3, r6, 6
    str r4, r6, 7
    ldi r2, r6, 5
    ldi r3, r6, 6
    ldi r4, r6, 7
    and r3, r3, r2
    not r2, r2
    and r4, r4, r2
    add r1, r3, r4
    str r0, r6, 6
    str r1, r6, 7
    ldr r0, r6, 0
    ldr r1, r6, 1
    ldr r2, r6, 2
    ldr r3, r6, 3
    ldr r4, r6, 4
    add r6, r6, 12
    ret

md5_gfunc:
    add r6, r6, -14
    str r0, r6, 3
    str r1, r6, 4
    str r2, r6, 5
    str r7, r6, 6
    ldr r0, r6, 7
    ldr r1, r6, 8
    ldr r2, r6, 9
    str r0, r6, 1
    str r1, r6, 2
    str r2, r6, 0
    jsr md5_ffunc
    ldr r0, r6, 0
    str r0, r6, 7
    ldr r1, r6, 1
    str r1, r6, 8
    ldr r0, r6, 2
    ldr r1, r6, 3
    ldr r2, r6, 4
    ldr r7, r6, 5
    add r6, r6, 14
    ret

md5_hfunc:
    add r6, r6, -10
    str r0, r6, 0
    str r1, r6, 1
    str r2, r6, 2
    str r3, r6, 3
    str r4, r6, 4
    ldi r0, r6, 5
    ldi r1, r6, 6
    and r2, r0, r1
    not r2, r2
    not r0, r0
    not r1, r1
    and r0, r0, r1
    not r0, r0
    and r0, r0, r2
    ldi r1, r6, 7
    and r2, r0, r1
    not r2, r2
    not r0, r0
    not r1, r1
    and r0, r0, r1
    not r0, r0
    and r3, r0, r2
    ldr r0, r6, 5
    ldr r1, r6, 6
    ldr r2, r6, 7
    add r0, r0, 2
    add r1, r1, 2
    add r2, r2, 2
    str r0, r6, 5
    str r1, r6, 6
    str r2, r6, 7
    ldi r0, r6, 5
    ldi r1, r6, 6
    and r2, r0, r1
    not r2, r2
    not r0, r0
    not r1, r1
    and r0, r0, r1
    not r0, r0
    and r0, r0, r2
    ldi r1, r6, 7
    and r2, r0, r1
    not r2, r2
    not r0, r0
    not r1, r1
    and r0, r0, r1
    not r0, r0
    and r4, r0, r2
    str r3, r6, 6
    str r4, r6, 7
    ldr r0, r6, 0
    ldr r1, r6, 1
    ldr r2, r6, 2
    ldr r3, r6, 3
    ldr r4, r6, 4
    add r6, r6, 12
    ret

md5_ifunc:
    add r6, r6, -10
    str r0, r6, 0
    str r1, r6, 1
    str r2, r6, 2
    str r3, r6, 3
    str r4, r6, 4
    ldi r0, r6, 5
    ldi r1, r6, 7
    not r0, r0
    and r1, r1, r0
    not r1, r1
    ldi r0, r6, 6
    and r2, r0, r1
    not r2, r2
    not r0, r0
    not r1, r1
    and r0, r0, r1
    not r0, r0
    and r3, r0, r2
    ldr r0, r6, 5
    ldr r1, r6, 6
    ldr r2, r6, 7
    add r0, r0, 2
    add r1, r1, 2
    add r2, r2, 2
    str r0, r6, 5
    str r1, r6, 6
    str r2, r6, 7
    ldi r0, r6, 5
    ldi r1, r6, 7
    not r0, r0
    and r1, r1, r0
    not r1, r1
    ldi r0, r6, 6
    and r2, r0, r1
    not r2, r2
    not r0, r0
    not r1, r1
    and r0, r0, r1
    not r0, r0
    and r4, r0, r2
    str r3, r6, 6
    str r4, r6, 7
    ldr r0, r6, 0
    ldr r1, r6, 1
    ldr r2, r6, 2
    ldr r3, r6, 3
    ldr r4, r6, 4
    add r6, r6, 12
    ret

memcpy:
    add r6, r6, -8
    str r0, r6, 0
    str r1, r6, 1
    str r2, r6, 2
    str r3, r6, 3
    ldr r3, r6, 4
    ldr r0, r6, 6
    ldr r1, r6, 5
    not r2, r0
    add r2, r2, 1
    add r2, r2, r1
    brp memcpy_bw

memcpy_loop:
    add r3, r3, -1
    brn memcpy_done
    ldb r2, r0, 0
    stb r2, r1, 0
    add r0, r0, 1
    add r1, r1, 1
    br memcpy_loop

memcpy_bw:
    add r0, r0, r3
    add r1, r1, r3

memcpy_bw_loop:
    add r3, r3, -1
    brn memcpy_done
    add r0, r0, -1
    add r1, r1, -1
    ldb r2, r0, 0
    stb r2, r1, 0
    br memcpy_bw_loop

memcpy_done:
    ldr r0, r6, 0
    ldr r1, r6, 1
    ldr r2, r6, 2
    ldr r3, r6, 3
    add r6, r6, 14
    ret

segment
message_len:
    data4 ?

message:
    data4 ?
