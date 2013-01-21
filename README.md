Oppidum Tutorial
=======

Oppidum Tutorial is a simple [Oppidum](http://ssire.github.com/oppidum/) application that shows some Oppidum basics. It implements a simple website with a Home page and a variable number of Chapters (initially none). Authenticated users are able to edit the Home page and to add or change some Chapters. This way the tutorial shows :

- how to write a web application controller using Oppidum's mapping language (see `controller.xql`)
- how to write a mesh page to factorize web application pages building blocks such as header, login menu, navigation box, etc. (see `mesh/standard.xhtml`)
- how to write an epilogue that renders a mesh page with some content (see `epilogue.xql`)
- how to declare the web application CSS and Javascript files into a skin file (see `config/skin.xml`)
- how to write XQuery and XSLT scripts to generate a web application page content
- how to use an XTiger XML template (see `templates/page.xhtml`) with the [AXEL](http://ssire.github.com/axel/) and [AXEL-FORMS](http://ssire.github.com/axel-forms/) libraries to make some pages editable, some runtime version of those libraries are packaged with Oppidum

Oppidum is an XML-oriented MVC framework written in XQuery / XSLT / Javascript. 

It allows to develop applications on top of the [eXist-db]([http://exist-db.org/) native XML database. It is designed to create custom content management solutions (CMS) involving lighweight XML authoring chains. Oppidum is developped and maintained by Stéphane Sire at [Oppidoc](http://www.oppidoc.com).

How to test it ?
----------------

You need to install [eXist-db](http://exist-db.org/exist/download.xml) on your system first. Use a 1.4.x version as we need to reorganize a little code layout for eXist 2.0.  

Then clone Oppidum from the [Oppidum's repository](https://github.com/ssire/oppidum) directly inside the `webapp` folder of your eXist installation. We strongly advise to create a `projets` folder inside the `webapp` folder and to checkout Oppidum within that folder (note that currently you MUST call this folder `projets` in french - _this will be corrected_) :

    cd {eXist-Home}/webapp
    mkdir projets
    cd projets
    git clone git://github.com/ssire/oppidum.git

For convenience Oppidum distribution contains a `script/start.sh` shell script that you can use to start eXist-db. Then you can point your browser to `http://localhost:8080/exist/projets/oppidum` to see a version screen. You can use the `script/stop.sh` to stop it (edit the file to set your database password within it). 

Once you have checked Oppidum is running, you can clone the Oppidum tutorial from this repository directly inside the `projets` folder :

    cd {eXist-Home}/webapp
    cd projets
    git clone git://github.com/ssire/tutorial.git
  
You should then be able to open the `http://localhost:8080/exist/projets/tutorial` url to access the tutorial.

The next step is to install some configuration files from Oppidum and from the Tutorial inside the database. For that purpose :

- open the `http://localhost:8080/exist/projets/oppidum/install` url then check the `config` group and click on the install button
- open the `http://localhost:8080/exist/projets/tutorial/install` url then check all the `Data` and `Code` groups and click on the install button

Note that you must login as a database admin to execute the installation scripts.

 