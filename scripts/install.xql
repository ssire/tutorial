xquery version "1.0";
(: --------------------------------------
   Oppidum tutorial installation

   Author: Stéphane Sire <s.sire@free.fr>
   
   September 2011
   -------------------------------------- :)

import module namespace install = "http://oppidoc.com/oppidum/install" at "../../oppidum/lib/install.xqm";   

declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

declare variable $policies := <policies xmlns="http://oppidoc.com/oppidum/install">
  <user name="membre" password="test" groups="site-member" home=""/> 
  <policy name="read" owner="admin" group="dba" perms="rwur--r--"/>
  <policy name="write" owner="admin" group="site-member" perms="rwur-ur--"/>
  <policy name="write-delete-add" owner="admin" group="site-member" perms="rwurwur--"/>
</policies>;

declare variable $site := <site xmlns="http://oppidoc.com/oppidum/install">
  <collection name="/db/sites/tutorial" policy="read"/>
  <group name="config">
    <collection name="/db/sites/tutorial/config" policy="read" inherit="true">
      <files pattern="init/error.xml"/>
    </collection>
  </group>
  <group name="data">
    <collection name="/db/sites/tutorial/pages" policy="write" inherit="true">
      <files pattern="init/home.xml"/>
    </collection>
    <collection name="/db/sites/tutorial/chapters" policy="write-delete-add"/>
    <collection name="/db/sites/tutorial/images" policy="write-delete-add"/>
  </group>
  <group name="mesh">
    <collection name="/db/sites/tutorial/mesh" policy="read" inherit="true">
      <files pattern="mesh/*.html"/>
    </collection>
  </group>
  <group name="templates" policy="read" inherit="true">
    <files pattern="templates/*" type="text/xml" preserve="true"/>
  </group>
</site>;

declare variable $code := <code xmlns="http://oppidoc.com/oppidum/install">
  <collection name="/db/www/tutorial" policy="read" inherit="true"/>
  <group name="resources">
    <collection name="/db/www/tutorial">
      <files pattern="resources/**/*.css" preserve="true"/>
    </collection>
  </group>
</code>;

install:install("projets/tutorial", $policies, $site, $code, "Tutorial")
