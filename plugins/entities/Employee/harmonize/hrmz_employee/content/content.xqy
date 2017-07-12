xquery version "1.0-ml";
module namespace plugin = "http://marklogic.com/data-hub/plugins";
import module namespace functx = "http://www.functx.com" at "/MarkLogic/functx/functx-1.0-nodoc-2007-01.xqy";

declare namespace envelope = "http://marklogic.com/data-hub/envelope";
declare option xdmp:mapping "false";

declare function add-start-date($node, $name, $reference)
{
  typeswitch($node)
    case element() return
      if (starts-with(local-name($node), $name))
      then
        functx:add-attributes($node, xs:QName("Start-Date"),
                functx:dynamic-path($reference,fn:lower-case(local-name($node)))/data()
        )
      else
        element { fn:node-name($node) } {
          $node/@*,
          $node/node() ! add-start-date(., $name, $reference)
        }

    default return $node
};

declare function get-skill-description($skill as node()) {
  let $skilldescrip := cts:search(
    collection("skills")//envelope:content,
    cts:element-query(xs:QName("SkillId"), $skill//SkillId))
  return element skill {
    $skill/consultantskill/child::*,
    $skilldescrip//Description
  }
};

(:~
 : Create Content Plugin
 : @param $id          - the identifier returned by the collector
 : @param $options     - a map containing options. Options are sent from Java
 : @return - your transformed content
 :)
declare function plugin:create-content($id as xs:string, $options as map:map) as node()? {
  let $doc := fn:doc($id)
  let $consultantid := $doc/envelope:envelope/envelope:content/consultant/ConsultantId/text()
  
  (: stash the consultantid in the options map for later :)
  let $_ := map:put($options, "final-doc-uri", $consultantid)

  let $skills := cts:search(
    collection("consultantskills")//envelope:content,
    cts:element-query(xs:QName("ConsultantId"), $consultantid))

  let $allskills := for $skill in $skills
    return get-skill-description($skill)
  
  let $assignments :=

      xdmp:invoke-function(
              function() {
                  cts:search(
                          collection("assignment")//envelope:content,
                          cts:element-query(xs:QName("Employee_Number"), $consultantid))[1]
              },
              <options xmlns="xdmp:eval">
                  <database>{xdmp:database("cg-ef-datahub-FINAL")}</database>
              </options>)




  return element consultant {
    $doc//envelope:content/consultant/child::*,
    ( element skills { $allskills } ),
    ( element assignments { $assignments//assignment/child::* } )
  }
};
