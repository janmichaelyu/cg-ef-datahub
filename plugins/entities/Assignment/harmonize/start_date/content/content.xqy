xquery version "1.0-ml";

module namespace plugin = "http://marklogic.com/data-hub/plugins";
import module namespace functx = "http://www.functx.com" at "/MarkLogic/functx/functx-1.0-nodoc-2007-01.xqy";

declare option xdmp:mapping "false";

declare function plugin:change($node, $name, $reference)
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
          $node/node() ! plugin:change(., $name, $reference)
        }

    default return $node
};

(:~
 : Create Content Plugin
 :
 : @param $id          - the identifier returned by the collector
 : @param $options     - a map containing options. Options are sent from Java
 :
 : @return - your transformed content
 :)
declare function plugin:create-content(
        $id as xs:string,
        $options as map:map) as node()?
{
  let $_ := xdmp:log("doc: " || $id)
  let $doc := fn:doc($id)

  let $reference := collection("WeeklyReference")[1]//*:weeks
  let $_ := xdmp:log("reference: " || collection("WeeklyReference")[1]//*:weeks/*[1])

  let $content := plugin:change($doc/*[1], "Week", $reference)

  return $content//*:content/assignment
};

