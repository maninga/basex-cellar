(:~ 
: users rest api
: @author andy bunce
: @since jun 2012
:)

module namespace auth = 'apb.users.app';
declare default function namespace 'apb.users.app';

import module namespace web = 'apb.web.utils2' at "webutils.xqm";
import module namespace users = 'apb.users.app' at "user-db.xqm";



import module namespace session ="http://basex.org/modules/session";
declare namespace rest = 'http://exquery.org/ns/restxq';


declare variable $auth:userdb:=db:open('users',"users.xml")/users;							

                           
(:~
: return all users as json if this session is for admin
: auth required
:)
declare
%rest:GET %rest:path("cellar/api/users")  
%output:method("json")
function users()
{
   web:role-check("admin",function(){
       <json arrays="json" objects="user">
		      {for $u in $auth:userdb/user
			  order by fn:number($u/stats/@logins) descending
			  return <user>
			      <id>{$u/@id/fn:string()}</id>
				  <name>{$u/name/fn:string()}</name>
				  <created>{$u/stats/@created/fn:string()}</created>
				  <last>{$u/stats/@last/fn:string()}</last>
				  <logins>{$u/stats/@logins/fn:string()}</logins>
				   <avatar>{$u/avatar/fn:string()}</avatar>
				  </user>}
		</json>}   
)};

(:~
: full details for user with id as json
:)
declare
%rest:GET %rest:path("cellar/api/users/{$id}")  
%output:method("json")
function get-user(
  $id)
{
 let $u:=$auth:userdb/user[@id=$id]
 return if($u) then
            <json objects="json"> 
                  <id>{$u/@id/fn:string()}</id>
                  <name>{$u/name/fn:string()}</name>
                  <created>{$u/stats/@created/fn:string()}</created>
                  <last>{$u/stats/@last/fn:string()}</last>
                  <logins>{$u/stats/@logins/fn:string()}</logins>
                  <avatar>{$u/avatar/fn:string()}</avatar>
              </json>
      else 
           web:status(404,"Not found: " || $id)    
}; 

(:~
: full private for user with id as json
:)
declare
%rest:GET %rest:path("cellar/api/users/{$id}/data/{$field}")  
%output:method("json")
function get-user-data(
  $id,$field)
{
 let $u:=$auth:userdb/user[@id=$id]
 let $v:= users:get-data($auth:userdb, $id ,"markers")

 return  if($v) then $v
         else  <json objects="json"/> 
                 
};

(: TODO PERMISSIONS :)
declare updating
%rest:PUT("{$body}") %rest:path("cellar/api/users/{$id}/data/{$field}")  
%output:method("json")
function put-user-data(
  $id,$field,$body)
{
 let $u:=$auth:userdb/user[@id=$id]
 let $body:=fn:trace($body,"body")
 return  users:put-data($auth:userdb, $id ,"markers",$body)
};