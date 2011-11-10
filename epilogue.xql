xquery version "1.0";
(: -----------------------------------------------
	 Oppidum Tutorial Epilogue 

	 Author: Stéphane Sire <s.sire@free.fr>

   November 2011 - Copyright (c) Oppidoc S.A.R.L
   ----------------------------------------------- :)

declare namespace site = "http://oppidoc.com/oppidum/site";
declare namespace request = "http://exist-db.org/xquery/request";
declare namespace xdb = "http://exist-db.org/xquery/xmldb";
declare namespace session = "http://exist-db.org/xquery/session";

import module namespace oppidum = "http://oppidoc.com/oppidum/util" at "../oppidum/lib/util.xqm";
import module namespace epilogue = "http://oppidoc.com/oppidum/epilogue" at "../oppidum/lib/epilogue.xqm";

declare option exist:serialize "method=xhtml media-type=text/html indent=yes";
(:     doctype-public=-//W3C//DTD&#160;XHTML&#160;1.1//EN
     doctype-system=http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"; :) 
     
(: ======================================================================
   Typeswitch function 
   -------------------
   Plug all the <site:{module}> functions here and define them below  
   ======================================================================
:)
declare function site:branch( $cmd as element(), $source as element(), $view as element()* ) as node()*
{
 typeswitch($source)
 case element(site:link) return site:link($cmd, $view)
 case element(site:script) return site:script($cmd, $view)
 case element(site:login) return site:login($cmd)
 case element(site:home) return site:home($cmd, $view)
 case element(site:navigation) return site:navigation($cmd, $view)
 case element(site:error) return site:error($cmd, $view)
 case element(site:message) return site:message($view)
 case element(site:image) return site:image($source)
 default return $view/*[local-name(.) = local-name($source)]/*  
 (: default treatment to implicitly manage other modules :)
};  

(: ======================================================================
   Converts <site:image> static image link
   ====================================================================== 
:)
declare function site:image($image as element()) as element()*
{      
  epilogue:img-link('tutorial', concat('images/', $image/@src))
};                         

(: ======================================================================
   Inserts <site:link> static CSS links to the page
   ======================================================================
:)     
declare function site:link( $cmd as element(), $view as element() ) as element()*
{       
  if ($cmd/@action = ('modifier', 'ajouter')) then
    (
    epilogue:css-link('tutorial', ('css/site.css', 'css/page.css'), ()),
    epilogue:css-link('oppidum', (), ('axel', 'photo')) (: axel with photo plugin :)
    )
  else 
    epilogue:css-link('tutorial', ('css/site.css', 'css/page.css'), ())
};

(: ======================================================================
   Inserts <site:script> static script elements
   ======================================================================
:)     
declare function site:script( $cmd as element(), $view as element() ) as element()*
{  
  if ($cmd/@action = ('modifier', 'ajouter')) then
    epilogue:js-link('oppidum', (), ('jquery', 'axel', 'photo')) (: jquery and axel with photo plugin :)
  else
    ()
};

(: ======================================================================
   Handles <site:login> LOGIN banner
   ====================================================================== 
:)
declare function site:login( $cmd as element() ) as element()* 
{                          
 let 
   $uri := request:get-uri(),
   $user := xdb:get-current-user()
   (:   $is-admin := ($user = 'admin') or (xdb:get-user-groups($user)[. = 'site-admin']);:)
 return 
   if ($user = 'guest')  then
     if (not(ends-with($uri, '/login'))) then
       <a class="login" href="{$cmd/@base-url}login?url={$uri}">LOGIN</a>
     else 
       ()
   else      
    (
    <span>{$user}</span>,
    <a class="login" href="{$cmd/@base-url}logout?url={$cmd/@base-url}">LOGOUT</a>
    )
};      

(: ======================================================================
   Generates error essages in <site:error>
   ======================================================================
:) 
declare function site:error( $cmd as element(), $view as element() ) as node()*
{                          
  oppidum:render-errors($cmd/@db, $cmd/@lang)
};                 

(: ======================================================================
   Generates information messages in <site:message>
   Be careful to call session:invalidate() to clear the flash after logout
   redirection !
   TODO: store messages in a database 
   ======================================================================
:) 
declare function site:message( $view as element() ) as node()*
{                          
 attribute class { 'active' },
 for $e in oppidum:get-messages()
 let $type := substring-before($e, ':'), $object := substring-after($e, ':')
 return
   if ($type = 'ACTION-DELETE-SUCCESS') then
     <p>La revue "<span>{$object}</span>" a été supprimée</p>
   else if ($type = 'ACTION-DELETE-FAILURE') then
     <p>La revue "<span>{$object}</span>" n'a pas été supprimée car vous n'avez pas saisi le bon numéro</p>
   else if ($type = 'ACTION-LOGIN-SUCCESS') then
     <p>Vous avez été identifié en tant que "<span>{$object}</span>"</p>
   else if ($type = 'ACTION-LOGOUT-SUCCESS') then
     (
     session:invalidate(),
     <p>Vous avez été déconnecté avec succès</p>
     )
   else if ($type = 'ACTION-UPDATE-SUCCESS') then
     <p>La ressource a été enregistrée avec succès</p>
   else if ($type = 'ACTION-ACTIVATED') then
     <p>Le rédacteur {$object} a été activé</p>
   else if ($type = 'ACTION-DESACTIVATED') then
     <p>Le rédacteur {$object} a été désactivé</p>
   else
     ()
};   

(: ======================================================================
	 Handles <site:home> basic trail
	 Displays Home on any page other than the /home page
   ======================================================================
:) 
declare function site:home( $cmd as element(), $view as element() ) as element()*
{
  if ($cmd/@trail != 'home') then
    <a href="{concat($cmd/@base-url, 'home')}">Home</a>
  else
    ()
};
 
(: ======================================================================
   Generates <site:navigation> navigation menu
   Creates one entry for each page in the '/db/sites/tutorial' collection
   Adds a button if the user has the right to create extra pages   
   ======================================================================
:)    
declare function site:navigation( $cmd as element(), $view as element() ) as element()*
{                                             
  let $rights := tokenize(request:get-attribute('oppidum.rights'), ' ')
  let $chapters := xdb:get-child-resources(concat($cmd/@db, '/chapters'))
  return (        
    for $c in $chapters
    let $m := text:groups($c, '^(\d+)')
    where count($m) > 0
    return 
      <li>{
        if ($cmd/resource/@name = $m[2]) then
          <b><a href="{concat($cmd/@base-url, 'chapitres/', $m[2])}">{$m[2]}</a> *</b>
        else
          <a href="{concat($cmd/@base-url, 'chapitres/', $m[2])}">{$m[2]}</a>
      }</li>,
    if ('modifier' = $rights) then
      <li><button onclick='javascript:window.location.href=''{concat($cmd/@base-url, "chapitres/ajouter")}'''>Ajouter</button></li>
    else
      ()
  )
};

(: ======================================================================
   Recursive rendering function 
   ----------------------------
   Copy this function as is inside your epilogue to render a mesh
   ======================================================================
:)
declare function local:render( $cmd as element(), $source as element(), $view as element()* ) as element()
{		 
	element { node-name($source) }
	{
		$source/@*,
		for $child in $source/node()
		return		       
		  if ($child instance of text()) then
	      $child
	    else
				(: FIXME: hard-coded 'site:' prefix we should better use namespace-uri :)
				if (starts-with(xs:string(node-name($child)), 'site:')) then
					(		                   
						if (($child/@force) or 
								($view/*[local-name(.) = local-name($child)])) then
                 site:branch($cmd, $child, $view)
						else
							()
					)
				else if ($child/*) then
				  if ($child/@condition) then
 				  let $go :=  
 				    if (string($child/@condition) = 'has-error') then
 				      oppidum:has-error()
 				    else if (string($child/@condition) = 'has-message') then
 			        oppidum:has-message()
 			      else if ($view/*[local-name(.) = substring-after($child/@condition, ':')]) then 
  			        true()
 			      else 
 			        false()
 				  return
 					  if ($go) then        
 						  local:render($cmd, $child, $view)
 						else 
 						  () 
 			  else 
           local:render($cmd, $child, $view)  			    
			  else
         $child
	}
};		    

(: ======================================================================
   Epilogue entry point
   --------------------
   Copy this code as is inside your epilogue
   ======================================================================
:)
let $mesh := epilogue:finalize()
return
  if ($mesh) then
    local:render(request:get-attribute('oppidum.command'), $mesh, request:get-data())
  else 
    ()
