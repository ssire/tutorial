xquery version "1.0";         
(: -----------------------------------------------
	 Oppidum Tutorial controller 

	 Author: Stéphane Sire <s.sire@free.fr>

   November 2011 - Copyright (c) Oppidoc S.A.R.L
   ----------------------------------------------- :)
                          
import module namespace gen = "http://oppidoc.com/oppidum/generator" at "../oppidum/lib/pipeline.xqm";

(: ======================================================================
                  Site default access rights
   ====================================================================== :)                 
declare variable $access := <access>
  <rule action="install" role="u:admin" message="administrateur"/>
  <rule action="ajouter modifier POST" role="u:admin g:site-member" message="membre"/>
</access>;

(: ======================================================================
                  Site default actions
   ====================================================================== :)                 
declare variable $actions := <actions error="models/error.xql">
  <action name="login" depth="0" epilogue="standard"> <!-- may be GET or POST --> 
    <model src="oppidum:actions/login.xql"/>
    <view src="oppidum:views/login.xsl"/>
  </action>  
  <action name="logout" depth="0"> 
    <model src="oppidum:actions/logout.xql"/>
  </action>
  <!-- NOTE: unplug this action from @supported on mapping's root node in production --> 
  <action name="install" depth="0"> 
    <model src="scripts/install.xql"/>
  </action>
</actions>;

(: ======================================================================
                  Site mappings
   ====================================================================== :)                 
declare variable $mapping := <site db="/db/sites/tutorial" startref="home" supported="login logout install">
  <error mesh="standard"/>
  <item name="home" epilogue="standard" collection="pages" resource="home.xml" supported="modifier" method="POST" template="templates/page">
    <model src="oppidum:actions/read.xql"/>
    <view src="views/page.xsl"/>
    <action name="modifier" epilogue="standard">
      <model src="oppidum:actions/edit.xql"/>
      <view src="oppidum:views/edit.xsl"/>
    </action>
    <action name="POST">
      <model src="oppidum:actions/write.xql"/>
    </action>    
  </item> 
  <collection name="chapitres" epilogue="standard" collection="chapters" supported="ajouter" method="POST" template="templates/page">
    <item epilogue="standard" resource="$2.xml" supported="modifier" method="POST" template="templates/page" check="true">
      <model src="oppidum:actions/read.xql"/>
      <view src="views/page.xsl"/>
      <action name="modifier" epilogue="standard">
        <model src="oppidum:actions/edit.xql"/>
        <view src="oppidum:views/edit.xsl"/>
      </action>
      <action name="POST">
        <model src="oppidum:actions/write.xql"/>
      </action>        
    </item>
    <action name="ajouter" epilogue="standard">
      <model src="oppidum:actions/bootstrap.xql"/>
      <view src="oppidum:views/edit.xsl"/>
    </action>    
    <action name="POST">
      <model src="modules/chapters/post.xql"/>
    </action>      
  </collection>
  <collection name="images" collection="images" method="POST">
    <action name="POST">
      <model src="oppidum:modules/images/upload.xql"/>
    </action>
    <item resource="$2" collection="images">
      <model src="oppidum:modules/images/image.xql"/>
      <variant name="GET" format="jpeg"/>
      <variant name="GET" format="png"/>
    </item>
  </collection>
  <collection name="templates">
    <model src="oppidum:models/templates.xql"/>
    <item name="page" collection="templates" resource="page.xhtml">
      <model src="oppidum:models/template.xql"/>
    </item>
  </collection>
</site>;

(: call oppidum:process with false() to disable ?debug=true mode :)
gen:process($exist:root, $exist:prefix, $exist:controller, $exist:path, 'fr', true(), $access, $actions, $mapping)
