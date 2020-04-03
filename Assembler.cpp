#include <bits/stdc++.h>

using namespace std;

const int oo=1e9;

map<string,int>opcode,type;
map<string,int>labels;

inline void initiate()
{
	int fixed;
	// Two Operands
	fixed=0;
	opcode["add"]=fixed,type["add"]=0;
	opcode["adc"]=1<<12,type["adc"]=0;
	opcode["sub"]=2<<12,type["sub"]=0;
	opcode["sbc"]=3<<12,type["sbc"]=0;
	opcode["xnor"]=4<<12,type["xnor"]=0;
	opcode["or"]=5<<12,type["or"]=0;
	opcode["cmp"]=6<<12,type["cmp"]=0;
	opcode["and"]=7<<12,type["and"]=0;
	opcode["mov"]=8<<12,type["mov"]=0;

	// One Operand
	fixed=7<<13;
	opcode["inc"]=fixed,type["inc"]=1;
	opcode["dec"]=fixed+(1<<8),type["dec"]=1;
	opcode["clr"]=fixed+(2<<8),type["clr"]=1;
	opcode["inv"]=fixed+(3<<8),type["inv"]=1;
	opcode["lsr"]=fixed+(4<<8),type["lsr"]=1;
	opcode["ror"]=fixed+(5<<8),type["ror"]=1;
	opcode["rrc"]=fixed+(6<<8),type["rrc"]=1;
	opcode["asr"]=fixed+(7<<8),type["asr"]=1;
	opcode["lsl"]=fixed+(8<<8),type["lsl"]=1;
	opcode["rol"]=fixed+(9<<8),type["rol"]=1;
	opcode["rlc"]=fixed+(10<<8),type["rlc"]=1;

	// NO Operand
	fixed = 15<<12;
	opcode["nop"]=fixed,type["nop"]=2;
	opcode["hlt"]=fixed+(1<<11),type["hlt"]=2;

	// Branching
	fixed=3<<14;
	opcode["br"]=fixed,type["br"]=3;
	opcode["beq"]=fixed+(1<<10),type["beq"]=3;
	opcode["bne"]=fixed+(2<<10),type["bne"]=3;
	opcode["blo"]=fixed+(3<<10),type["blo"]=3;
	opcode["bls"]=fixed+(4<<10),type["bls"]=3;
	opcode["bhi"]=fixed+(5<<10),type["bhi"]=3;
	opcode["bhs"]=fixed+(6<<10),type["bhs"]=3;

	//Registers

}

int StoI(string s)
{
	// Sign happens in variables and branching offset only
	// Branching sign bit -> 10
	// Variable sign bit -> 16
	bool sign=0;
	if(s[0]=='-')	s=s.substr(1,s.size()-1),sign=1;
	int ret=0;
	for(auto& e:s)
	{
		ret*=10;
		ret+=e-'0';
	}
	if(sign)	ret*=-1;
	return ret;
}

inline void getRegister(vector<string>& ret, string cur)
{
	//+ => AI
	//- => AD
	//& => Indexed
	//$ => Reg
	//# => Variable
	//% => Number
	//@ => Indirect
	//^ => Direct
	bool fl=0,ind=0;
	if((int)(cur.find('@'))!=-1)	ind=1;
	if((int)(cur.find('+'))!=-1)	ret.push_back(((ind)?"@+":"^+")),fl=1;
	else if((int)(cur.find('-'))!=-1) ret.push_back(((ind)?"@-":"^-")),fl=1;
	else if((int)(cur.find('('))!=-1) ret.push_back(((ind)?"@":"^")+cur.substr((cur[0]=='@'),cur.find('(')-(cur[0]=='@'))),fl=1;

	if((int)(cur.find('r'))!=-1)
	{
		if(!fl)	ret.push_back(((ind)?"@$":"^$"));
		ret.push_back(cur.substr(cur.find('r')+1,1));
	}
	else
	{
		if((int)(cur.find('#'))==-1)	ret.push_back("%"),ret.push_back(cur);
		else ret.push_back("#"),ret.push_back(cur.substr(1,cur.size()-1));
	}
}

bool isNum(const string& cur)
{
	bool ret=1;
	for(int i=(cur[0]=='-') ; i<(int)cur.size() ; ++i)	ret&=isdigit(cur[i]);
	return ret;
}

bool isLabelUse(vector<string>& cur)
{
	bool flag=0;
	if(cur.size()==1 && (int)(cur[0].find(':'))!=-1)	flag=1;
	else if(type[cur[0]]==3 && !isNum(cur[1]))	flag=1;
	if(!flag)	return 0;

	if(cur.size()==1 && (int)(cur[0].find(':'))!=-1)
	{

		cur[0]=cur[0].substr(0,cur[0].size()-1);
		cur.push_back(":");
		swap(cur[0],cur[1]);
	}
	else
	{
		cur.push_back("::");
		swap(cur[2],cur[1]);
		swap(cur[1],cur[0]);
	}
	return 1;
}

vector<string> modify(const vector<string> & cur)
{
	vector<string>ret;
	ret.push_back(cur[0]);
	if(type[cur[0]]==3)	ret.push_back(cur[1]);
	if(type[cur[0]]&2)	return ret;

	getRegister(ret,cur[1]);
	if(cur.size()==2)	return ret;

	getRegister(ret,cur[2]);
	return ret;
}

int complement(int cur, int size=16)
{
	if(cur>=0)	return cur;
	cur*=-1;
	int ret=0;
	bool flag=0;
	for(int i=0 ; i<size ; ++i)
	{
		int here=1<<i;
		if(((here&cur) && !flag) || (!(here&cur) && flag))	ret+=here,flag=1;
	}
	return ret;
}

vector<vector<string>> parseInstructions(ifstream &Input)
{
	vector<vector<string>> ret;
	string s,t;
	while(getline(Input,s))
	{
		vector<string> cur;
		t="";
		if(s[0]=='#')
		{
			cur.push_back("#");
			cur.push_back(s.substr(1,s.size()-1));
			ret.push_back(cur);
			continue;
		}
		for(auto& e:s)
		{
			if(isalpha(e) && isupper(e))	e+='a'-'A';
			if(e==' ' || e==',' || e=='\t')
			{
				if(t.size())	cur.push_back(t),t="";
			}
			else t+=e;
		}
		if(t.size())	cur.push_back(t);
		if(isLabelUse(cur))	ret.push_back(cur);
		else ret.push_back(modify(cur));
	}
	return ret;
}

int main(int argc, char ** argv)
{
	ifstream Input(argv[1]);
	initiate();
	string s;
	vector<vector<string>> Ins = parseInstructions(Input);
	Input.close();
	vector<int> program;
	int line=-1;
	for(auto& e:Ins)
	{
		++line;
		// for(auto& r:e)	cout << r << " ";
		// cout << endl;
		// continue;
		if(e[0][0]=='#')
		{
			program.push_back(complement(StoI(e[1])));
			continue;
		}
		if(e[0]==":")
		{
			labels[e[1]]=program.size();
			continue;
		}
		if(e[0]=="::")
		{
			program.push_back(-(line+1));
			continue;
		}

		int cur=opcode[e[0]];
		int ty=type[e[0]];
		int a,b;
		a=b=oo;
		if(ty==0)
		{
			if(e[1].size()==2)
			{
				if(e[1][0]=='@')	cur+=(1<<11);
				if(e[1][1]=='$')	cur+=0;
				else if(e[1][1]=='+')	cur+=(1<<9);
				else if(e[1][1]=='-')	cur+=(2<<9);
				else a=StoI(e[1].substr(1,(int)e[1].size()-1)),cur+=(3<<9);

				cur+=((e[2][0]-'0')<<6);
			}
			else
			{
				if(e[1][0]=='#')	cur+=(15<<6),a=StoI(e[2]);
				else cur+=31<<6,a=StoI(e[2])-program.size();
			}

			if(e[3].size()==2)
			{
				if(e[3][0]=='@')	cur+=(1<<5);
				if(e[3][1]=='$')	cur+=0;
				else if(e[3][1]=='+')	cur+=(1<<3);
				else if(e[3][1]=='-')	cur+=(2<<3);
				else b=StoI(e[3].substr(1,(int)e[3].size()-1)),cur+=(3<<3);

				cur+=((e[4][0]-'0'));
			}
			else
			{
				if(e[3][0]=='#')	cur+=15,a=StoI(e[4]);
				else cur+=31,b=StoI(e[4])-program.size();
			}
		}
		else if(ty==1)
		{
			if(e[1].size()==2)
			{
				if(e[1][0]=='@')	cur+=(1<<5);
				if(e[1][1]=='$')	cur+=0;
				else if(e[1][1]=='+')	cur+=(1<<3);
				else if(e[1][1]=='-')	cur+=(2<<3);
				else a=StoI(e[1].substr(1,(int)e[1].size()-1)),cur+=(3<<3);

				cur+=((e[2][0]-'0'));
			}
			else
			{
				if(e[1][0]=='#')	cur+=15,a=StoI(e[2]);
				else cur+=31,a=StoI(e[2])-program.size();
			}
		}
		else if(ty==3)
		{
			int off=StoI(e[1]);
			if(off<0)
			{
				off=complement(off,9);
				off|=(1<<9);
			}
			cur+=off;
		}
		program.push_back(cur);
		//Handle -a & -b
		//######################################################
		if(a!=oo)	program.push_back(complement(a));
		if(b!=oo)	program.push_back(complement(b));
		//######################################################
	}
	line=-1;
	for(auto& e:program)
	{
		++line;
		if(e<0)
		{
			int insLine=-(e+1);
			e=opcode[Ins[insLine][1]];
			int off=labels[Ins[insLine][2]]-line;
			if(off<0)
			{
				off=complement(off,9);
				off|=(1<<9);
			}
			e+=off;
		}
	}

	int len=strlen(argv[1]);
	for(int i=0 ; i<len ; ++i)
		if(argv[1][i]=='.')
		{
			argv[1][i]=0;
			break;
		}
	string out=argv[1];
	out+=".bin";
	ofstream Output(out);
	for(auto& e:program)	Output << bitset<16>(e) << endl;
}
