RUNNING THE FRONT END
=====================

Dynamic
-------
Running the front end dynamically requires deploying to a server, building in to a container, or some other way where nodejs and npm are available to handle the dynamic rendering of the react app

1. npm install
2. set the environmental variable REACT_APP_SUBMIT_URL to point at the API endpoint
3. npm start

***Note:*** *this has all been tested with docker and may need some investigation to properly deploy on ECS*

Static
------
* UNTESTED
If you are familiar with create-react-app bootstrapped applications, you may want to try EJECTING the app and then running it as a static front end. This would be much lighter weight (and therefore less expensive), but would only require static hosting of the app using apache, nginx, or even an s3 bucket.
