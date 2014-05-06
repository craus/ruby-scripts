#pragma comment(linker, "/STACK:268435456")
#define _CRT_SECURE_NO_WARNINGS
#include <cstdio>
#include <iostream>
#include <algorithm>
#include <cmath>
#include <string>
#include <vector>
#include <set>
#include <map>
#include <deque>
#include <queue>
#include <list>
#include <cstring>
#include <complex>
#include <ctime>
#include <bitset>
#include <iomanip>
#include <sstream>
using namespace std;
const double PI = 3.1415926535897932384626433832795;
template<class T> T min(T &a, T &b) { return (a<b) ? a : b; }
template<class T> T max(T &a, T &b) { return (a>b) ? a : b; }
template<class T> T sqr(T &a) { return a*a; }
template<class T> T abs(T &a) { return (a<0) ? (-a) : a; }
typedef long long ll;
typedef long long LL;
typedef pair<int,int> ii;
#define all(v) (v).begin(),(v).end()
#define sz(v) ((int)((v).size()))
#define PB push_back
#define MP make_pair
#define CLR(a) memset((a),0,sizeof(a))
#define fori(i,n) for(int i=0;i<(n);i++)
//------------------------------------------------------------------------------

bool vis[2012];

vector<ii> v;

LL sum;

priority_queue<int> q;

LL curw;

LL a[3872];


LL X = 239;
LL M = 1000000007;

LL hsh(LL x)
{
	LL res = 0;
	for (int i = 0; i < 34; i++)
		if ((x >> i) & 1LL)
			res = (res+a[i])%M;
	return res;
}

int bitcount(LL x)
{
	int res = 0;
	for (int i = 0; i < 34; i++)
		if ((x >> i) & 1LL)
			res += 1;
	return res;
}

LL hs[1<<19];
int bc[1<<19];

map<LL, int> mp;
map<LL, LL> rs;
set<LL> st;

int main()
{
#ifdef TEDDY_BEARS
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
#endif

	a[0] = 1;
	for (int i = 1; i < 34; i++)
		a[i] = (a[i-1]*X) % M;

	for (int i = 0; i < (1<<17); i++)
	{
		hs[i] = hsh(i);
		bc[i] = bitcount(i);
	}

	int T;
	cin >> T;
	
	for (int t = 0; t < T; t++)
	{
		mp.clear();
		st.clear();
		rs.clear();
		int n;
		LL m;
		LL h;
		cin >> n >> m >> h;
		LL m0 = m;
		int r = n/2;
		int l = n - r;
		int res = n+123;
		LL ans = -17;
		
		for (int i = 0; i < (1<<r); i++)
		{
			LL right = (m&((1<<r)-1))^i;
			LL hashright = hs[right];

			mp[hashright] = bc[i];
			st.insert(hashright);
			rs[hashright] = (m&((1<<r)-1))^i;
		}
		m >>= r;
		for (int i = 0; i < (1<<l); i++)
		{
			LL left = (m&(((1<<l)-1)))^(i);
			LL hashleft = (hs[left] * a[r]) % M;

			LL hashright = (h + M - hashleft) % M;
			if (st.find(hashright) != st.end())
			{
				int curres = mp[hashright] + bc[i];
				if (curres < res)
				{
					res = curres;
					ans = (left<<r);
					ans |= rs[hashright];
				}
			}
		}
		m = m0;
		if (res > n)
			cout << -1;
		else
		{
			cout << res;
			for (int i = 0; i < n; i++)
				if (((ans>>i)&1) != ((m>>i)&1))
					cout << " " << i;
		}
		cout << endl;
	}

}