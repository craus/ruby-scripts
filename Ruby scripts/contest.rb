#include <iostream>
#include <string>
#include <cstdio>
#include <iostream>
#include <algorithm>
#include <ctime>
#include <map>
#include <vector>

using namespace std;

map<string, map<int,int> > mp;

struct c {
	int m1, m2, m3;
	string name;
	int place;
	
	c(int m1, int m2, int m3, string name) : m1(m1), m2(m2), m3(m3), name(name) {}
	
	const bool operator <(const c & b) const {
		if (m1 > b.m1) return true;
		if (m1 < b.m1) return false;
		if (m2 > b.m2) return true;
		if (m2 < b.m2) return false;
		if (m3 > b.m3) return true;
		if (m3 < b.m3) return false;
		return name < b.name;
	}
};

vector<c> cs;

int main() {
	int n;
	cin >> n;
	
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < 3; j++) {
			string s;
			cin >> s;
			//cout << "medal: " + s << endl;
			mp[s][j]++;
		}
	}
	for (map<string, map<int,int> >::iterator i = mp.begin(); i != mp.end(); i++) {
		cs.push_back(c(i->second[0], i->second[1], i->second[2], i->first));
	}
	sort(cs.begin(), cs.end());
	for (int i = 0; i < cs.size(); i++) {
		cs[i].place = i;
		if (i > 0 && cs[i].m1 == cs[i-1].m1 && cs[i].m2 == cs[i-1].m2 && cs[i].m3 == cs[i-1].m3) cs[i].place = cs[i-1].place;
		cout << cs[i].place+1 << " " << cs[i].name << " " << cs[i].m1 << " " << cs[i].m2 << " " << cs[i].m3 << endl;
	}
}