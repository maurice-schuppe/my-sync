// function to compute an expression using int value parameters
// 传值参数 -- 值传递不会改变参数的值

#include<iostream>

using namespace std;

int abc(int a, int b, int c)
{
	a = 100;
   return a + b + c;
}

int main()
{
	int x = 2, y = 3, z = 4;
   cout << "abc(x,y,z) = " << abc(x,y,z) << endl;
   cout << "x = " << x << ", " << "y = " << y << ", " << "z = " << z << endl;
   return 0;
}

