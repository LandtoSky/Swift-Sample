## Offline Queue (OQ)

This will describe **how the OQ behaves in some scenarios.** The offline queue executes an update each 5 minutes.

**Scenario: User creates a new property and the device is online all the time**

1. User creates a new property
- App saves the property locally
- App syncs with the server
- The End

PS: Nothing is added to the OQ in this scenario


**Scenario: User creates a new property and the device is offline all the time**

1. User creates a new property
- App saves the property locally
- App tries to sync with the server
- Sync Fail
- Request is added to the OQ
- The End

**Conflict: OQ tries to do a request and the device is online**

1. Offline queue starts
- Requests are grouped by url
- Requests are ordered by date
- Queue executes first group
- First request is executed
- Request is deleted from OQ
  - Group still have requests
  - Back to 5
- No more requests to execute
- Still has groups to be executed
  - Go to next group
    - Back to 5
- No more groups to be executed
- Wait for the next update

**Conflict: OQ tries to do a request but the device is still offline**

1. Offline queue starts
- Requests are grouped by url
- Requests are ordered by date
- Queue executes first group
- First request fails because the device is offline
- All requests in the group back to the queue
- Try to execute next group
- No more groups to be executed
- Wait for the next update

**Conflict: OQ try to do a request but gets a status code 500**

1. Offline queue starts
- Requests are grouped by url
- Requests are ordered by date
- Queue executes first group
- First request gets a 500 response status code
- All requests in the group back to the queue
- Try to execute next group
- No more groups to be executed
- Wait for the next update


**TODO: Conflict: OQ try to do a request but gets a status code 400**

1. Offline queue starts
- Requests are grouped by url
- Requests are ordered by date
- Queue executes first group
- First request gets a 400 response status code
- The request fail counter is incremented
- All requests in the group back to the queue
- Try to execute next group
- No more groups to be executed
- Wait for the next update
