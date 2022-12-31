#include <sys/time.h>

// microseconds
long MicroSecs() {
	struct timeval tv;
	gettimeofday(&tv, NULL);
	return (long long int)tv.tv_sec * 1000000 + tv.tv_usec;
}

// current date
int Date() {
	time_t t = time(NULL);
	struct tm tm = *localtime(&t);
	return (tm.tm_year + 1900) * 10000 + (tm.tm_mon + 1) * 100 + tm.tm_mday;
}

// seconds between two dates
int SecondsSince( int date1, int date2 ) {
	struct tm tm1, tm2;
	tm1.tm_year = date1 / 10000 - 1900;
	tm1.tm_mon = date1 / 100 % 100 - 1;
	tm1.tm_mday = date1 % 100;
	tm1.tm_hour = 0;
	tm1.tm_min = 0;
	tm1.tm_sec = 0;
	tm1.tm_isdst = -1;
	tm2.tm_year = date2 / 10000 - 1900;
	tm2.tm_mon = date2 / 100 % 100 - 1;
	tm2.tm_mday = date2 % 100;
	tm2.tm_hour = 0;
	tm2.tm_min = 0;
	tm2.tm_sec = 0;
	tm2.tm_isdst = -1;
	return (int)difftime(mktime(&tm1), mktime(&tm2));
}