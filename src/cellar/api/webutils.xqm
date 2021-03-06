(:~ 
: web utils
: @author andy bunce
: @since oct 2012
:)

module namespace web = 'apb.web.utils2';
declare default function namespace 'apb.web.utils2'; 

declare namespace rest = 'http://exquery.org/ns/restxq';
import module namespace session ="http://basex.org/modules/session";

(:~
: execute function fn if session has loggedin user with matching role else 401
:)
declare function role-check($role as xs:string,$fn){
  let $uid:=session:get("uid")
  return if($uid) then
        $fn()
         else http-auth("Whizz apb auth",())
};


declare function status($code,$reason){
   <rest:response>            
       <http:response status="{$code}" reason="{$reason}"/>
   </rest:response>
};

(:~
: REST created http://restpatterns.org/HTTP_Status_Codes/401_-_Unauthorized
:)
declare function http-auth($auth-scheme,$response){
   (
   <rest:response>            
       <http:response status="401" >
	       <http:header name="WWW-Authenticate" value="{$auth-scheme}"/>
	   </http:response>
   </rest:response>,
   $response
   )
};
(:~
: REST created http://restpatterns.org/HTTP_Status_Codes/201_-_Created
:)
declare function http-created($location,$response){
   (
   <rest:response>            
       <http:response status="201" >
	       <http:header name="Location" value="{$location}"/>
	   </http:response>
   </rest:response>,
   $response
   )
};

(:~
: redirect to ..
:)
declare function redirect($url as xs:string) 
 {
        <rest:response>         
           <http:response status="303" >
             <http:header name="Location" value="{$url}"/>
           </http:response>                      
       </rest:response>
};
