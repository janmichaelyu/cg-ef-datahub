xquery version "1.0-ml";

module namespace plugin = "http://marklogic.com/data-hub/plugins";

declare option xdmp:mapping "false";

(:~
 : Writer Plugin
 :
 : @param $id       - the identifier returned by the collector
 : @param $envelope - the final envelope
 : @param $options  - a map containing options. Options are sent from Java
 :
 : @return - nothing
 :)
declare function plugin:write(
  $id as xs:string,
  $envelope as node(),
  $options as map:map) as empty-sequence()
{
  xdmp:document-insert(
    $id,
    $envelope,
    <options xmlns="xdmp:document-insert">
      <permissions>{xdmp:default-permissions()}</permissions>
      <collections>
        <collection>data</collection>
        <collection>employees</collection>
      </collections>
    </options>
  )
};
