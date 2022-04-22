#import "ActivityWrapper.h"

os_activity_t CreateActivity() {
  return os_activity_create("DDSpanActivityReference", OS_ACTIVITY_CURRENT, OS_ACTIVITY_FLAG_DEFAULT);
}

os_activity_t CurrentActivity() {
  return OS_ACTIVITY_CURRENT;
}

