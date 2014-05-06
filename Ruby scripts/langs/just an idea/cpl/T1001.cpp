#include <iostream>
#include <vector>

using namespace std;

vector<double> a;

int main()
{
  int x;
  while (scanf("%d",&x) != -1)
    a.push_back(x);
  reverse(a.begin(), a.end());
  for (int i = 0; i < (int)a.size(); i++)
    a[i] = sqrt(a[i]);
  for (int i = 0; i < (int)a.size(); i++)
    printf("%f\n",a[i]);
}
  