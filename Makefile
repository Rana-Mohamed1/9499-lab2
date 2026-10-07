target1:
	./antivirusd.sh source_directory malicious 5
target2:
	./restore.sh source_directory malicious
target3:
	mkdir -p malicious