# CellarXQ #

The original Wine Cellar application is documented 
[here](http://coenraets.org/blog/2012/02/sample-application-with-angular-js/).
This is sample CRUD application built with Angular.js using a PHP and MySQL backend.

This fork has been updated to Angular 1.0.2, and some new features have been implemented.
The back end is written entirely in XQuery using the BaseX RESTXQ implementation. 
My goal was to add the additional features that a "real" application would require; including: 
- Authentication
- Logging
- Error handling
- Larger datasets
- Analytics
to determine if this approach is practical

## Installation
Pre-requisites: BaseX 7.5 running the basexhttp server
1. copy the `src/cellar` folder to the BaseX webapp folder
2. Run the `install.xq` script this creates the databases.

````
../bin/basexclient  -n $OPENSHIFT_INTERNAL_IP -p 15005 -U admin -P admin cellar/install.xq
````
### configuration data
The application looks for a file `cellar-config.xml` in the WEB-INF folder. This is
used to store site specific private configuration data, such as OAuth secrets. You will need
to create and populate this file.

````
<config>
    <twitter>
        <CONSUMER-KEY>...</CONSUMER-KEY>
        <CONSUMER-SECRET>...</CONSUMER-SECRET>
        <access-token>...</access-token>
        <access-token-secret>...</access-token-secret>
    </twitter>
   <github>
        <Client-Id>...</Client-Id>
        <Client-Secret>...</Client-Secret>
    </github>
</config
````

## Authentication

All REST calls return a 401 if not the session is not authorised, but this is not used directly
Instead a custom permission property is  defined on the Angular route definitions. This is a regular 
expression matched against the role.
  
````
.when('/users', {templateUrl : 'partials/user-list.xml',
                 permission:".*",
                 controller : UserCtrl})
   
````
The `$routeChangeStart` event looks for the permission property and redirects to the login
 page if required. It stores the original destination to redirect after a successful login.
````
$rootScope.$on('$routeChangeStart', function(event,next, current) {
    if (!Auth.isAuthenticated() && next.$route && next.$route.permission) {
      Auth.setReturn($location.$$url);
    //  Flash.add("warn","You must log in to access the page");
      return $location.path("/auth/login");
````
Users can use one of several login methods:
1. Local (with local registration)
2. Github Oauth
3. Twitter Oauth


###  local

### Github

## Analytics

## Busy indicator

## error handling

## Server

Where possible the following structure is used for the xml.

````
<entity-name id="..">
 <meta created="date" [modified=".."] /> 
 <field>..</field>
 ...
 </entity-name>
```` 



