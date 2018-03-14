# vimtutor学习
---
[https://asciinema.org/a/fYiwAdZpo2PtsxZ3ARVUQ1DIG](https://asciinema.org/a/fYiwAdZpo2PtsxZ3ARVUQ1DIG)


![](image/1.PNG)

![](image/2.PNG)

- 你了解vim有哪几种工作模式？

   (command-mode)

   (insert-mode)

   (visual-mode)

   (normal-mode) 

- Normal模式下，从当前行开始，一次向下移动光标10行的操作方法？如何快速移动到文件开始行和结束行？如何快速跳转到文件中的第N行？

 N G 跳转到文件的第N行

 G 文件结束行

 gg 文件开始行

CTRL G 看到行数n后，n+10 G 向下移动光标10行
 
- Normal模式下，如何删除单个字符、单个单词、从当前光标位置一直删除到行尾、单行、当前行开始向下数N行？

x 删除单个字符

dw 删除单个单词

d￥（美元符打不出来) 从当前光标位置删除到行尾

dd 删除整行

Ndd 删除当前行开始向下数N行

- 如何在vim中快速插入N个空行？如何在vim中快速输入80个-？
 
   press o+esc N次？

   先敲 ----- ， press v y pppppppppp次

- 如何撤销最近一次编辑操作？如何重做最近一次被撤销的操作？
  press u

  ctrl+R

- vim中如何实现剪切粘贴单个字符？单个单词？单行？如何实现相似的复制粘贴操作呢？

  v y p

- 为了编辑一段文本你能想到哪几种操作方式（按键序列）？

  press a /i/ A 
  

- 查看当前正在编辑的文件名的方法？查看当前光标所在行的行号的方法？

  ctrl+G

- 在文件中进行关键词搜索你会哪些方法？如何设置忽略大小写的情况下进行匹配搜索？如何将匹配的搜索结果进行高亮显示？如何对匹配到的关键词进行批量替换？
  /keyword 

  :set ic

  :set hls is
  
  substitute new for all 'old's on a line type       :s/old/new/g

  substitute phrases between two line #'s type       :#,#s/old/new/g

  substitute all occurrences in the file type        :%s/old/new/g

  ask for confirmation each time add 'c'             :%s/old/new/gc

- 在文件中最近编辑过的位置来回快速跳转的方法？
  
   打印曾经编辑的行数+G 返回到ctrl+G 的地方 ？

- 如何把光标定位到各种括号的匹配项？例如：找到(, [, or {对应匹配的),], or }
  
  在（，[，{上press %
- 在不退出vim的情况下执行一个外部程序的方法？

：

- 如何使用vim的内置帮助系统来查询一个内置默认快捷键的使用方法？如何在两个不同的分屏窗口中移动光标？

:help cmd

ctrl+w


