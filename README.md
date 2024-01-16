# NetworkDiagram
Tool to diagram networks, particularly for use in CCDC environments.

## ToDo
* Get Box Info
    * NMAP - Only externally facing services, still important to know
    * Ideally, local tool that generates a file describing the machine
* Format Box Info into File to parse into Diagram Creator
    * YAML?
    * Similar to KAPE Modules
* Create Diagram
    * Convert description file into visual representation of the box
    * Organize boxes such that they don't overlap
    * Connect boxes to router via lines
    * Display inter-box dependencies (databases)
* Allow for Diagram to be easily included in injects
    * Just screenshots?
    * If done in word, would allow for imports
        * Becomes more difficult to create diagram
    * Maybe can include the inject pdf as input, then output is inject pdf with diagrams appended to end?
