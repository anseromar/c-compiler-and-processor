int main() {
	int a = 1;
	int b = 0;
	int c = 1;
	
	if (a == b){
		if (c == 0){
			a = b;
		} else{
			int d;
			c = 0;
		}
	}

	if (a == b){}
	// Le dernier IF avant le ELSE est associé au token IFX.
	if (c == 0){
		a = b;
	} else{
		int d;
		c = 0;
	}
}
