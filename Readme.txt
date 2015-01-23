* Introduction

Chiplib is a tool for generating software, documents and other collateral for different microcontrollers
microprocessors. 

Typically, we use Memory Mapped Registers to perform IO, Control and Configure a processor chip. This is
usually done using pointers in C/C++. Every Silicon vendor provides such libraries or header files. However,
this is of varying quality and differing standards. Plus, there are no standard conventions that are followed.
All this means that when porting software from one platform to another, one spends a lot of time reading specs,
sample code and other collateral, and invariably spend a huge time relearning conventions. Chiplib aims to 
change that.

You can use Chiplib to generate C code, documents etc.. all in the same format so that you don't spend time
relearning conventions, but get right to the meat.
