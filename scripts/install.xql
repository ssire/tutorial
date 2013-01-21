xquery version "1.0";
(: --------------------------------------
   Oppidum tutorial installation

   Author: Stéphane Sire <s.sire@free.fr>
   
   September 2011
   -------------------------------------- :)

import module namespace install = "http://oppidoc.com/oppidum/install" at "../../oppidum/lib/install.xqm";   

declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

(: WARNING: do not forget to set the correct path below webapp here ! :)
declare variable $local:base := "/projets/tutorial";

declare variable $policies := <policies xmlns="http://oppidoc.com/oppidum/install">
  <user name="membre" password="test" groups="site-member" home=""/> 
  <policy name="read" owner="admin" group="dba" perms="rwur--r--"/>
  <policy name="write" owner="admin" group="site-member" perms="rwur-ur--"/>
  <policy name="write-delete-add" owner="admin" group="site-member" perms="rwurwur--"/>
</policies>;

declare variable $site := <site xmlns="http://oppidoc.com/oppidum/install">
  <collection name="/db/sites/tutorial" policy="read"/>
  <group name="data">
    <collection name="/db/sites/tutorial/pages" policy="write" inherit="true">
      <files pattern="init/home.xml"/>
    </collection>
    <collection name="/db/sites/tutorial/chapters" policy="write-delete-add"/>
    <collection name="/db/sites/tutorial/images" policy="write-delete-add"/>
  </group>
</site>;

declare variable $code := <code xmlns="http://oppidoc.com/oppidum/install">
  <collection name="/db/www/tutorial" policy="read" inherit="true"/>
  <group name="config">
    <collection name="/db/www/tutorial/config" policy="read" inherit="true">
      <files pattern="init/skin.xml"/>
    </collection>
  </group>
  <group name="mesh" mandatory="true">
    <collection name="/db/www/tutorial/mesh">
      <files pattern="mesh/*.html"/>
    </collection>
  </group>
  <group name="templates" policy="read" inherit="true">
    <collection name="/db/www/tutorial">
      <files pattern="templates/page.xhtml" type="text/xml" preserve="true"/>
      <files pattern="oppidum:templates/filter.xsl" type="text/xml" preserve="true"/>
    </collection>
  </group>
</code>;

declare variable $static := <static xmlns="http://oppidoc.com/oppidum/install">
  <group name="resources">
    <collection name="/db/www/oppidoc">
      <files pattern="resources/**/*.css" preserve="true"/>
      <files pattern="resources/**/*.js" preserve="true"/>
      <files pattern="resources/**/*.png" preserve="true"/>
      <files pattern="resources/**/*.jpg" preserve="true"/>
      <files pattern="resources/**/*.gif" preserve="true"/>
    </collection>
  </group>
</static>;

install:install($local:base, $policies, $site, $code, $static, "Tutorial", ())
