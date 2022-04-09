#include <iostream>
#include <unistd.h>
#include <chrono>
#include "client.hpp"

using namespace std;
using namespace chrono;
unsigned long long GetTime64() {
    return static_cast<unsigned long long int>(std::chrono::system_clock::now().time_since_epoch().count() / 1000);
}

void transaction() {
    cat::Transaction t("foo", "bar");
    t.AddData("foo", "1");
    t.AddData("bar", "2");
    t.AddData("foo is a bar");
    t.SetDurationStart(GetTime64() - 1000);
    t.SetTimestamp(GetTime64() - 1000);
    t.SetDurationInMillis(150);
    t.SetStatus(cat::SUCCESS);
    t.Complete();
}
void event() {
    cat::Event e("foo", "bar");
    e.AddData("foo", "1");
    e.AddData("bar", "2");
    e.AddData("foo is a bar");
    e.SetStatus(cat::SUCCESS);
    e.Complete();

    cat::logEvent("foo", "bar1");
    cat::logEvent("foo", "bar2", "failed");
    cat::logEvent("foo", "bar3", "failed", "k=v");
}

void metric() {
    cat::logMetricForCount("count");
    cat::logMetricForCount("count", 3);
    cat::logMetricForDuration("duration", 100);
}

int main()
{
	cout << "cppcat version: " << cat::version() << endl;
    cat::Config c = cat::Config();
	c.enableDebugLog = true;
	c.encoderType = cat::ENCODER_TEXT;
	cat::init("cat_cpp_client",c);
	for(int i =0;i<10;i++)
	{
        cout<<i<<endl;
        transaction();
		event();
		metric();
		sleep(1);
	}
	cout<< "finish"<<endl;
	sleep(1);
	cat::destroy();
	return 0;	
}
