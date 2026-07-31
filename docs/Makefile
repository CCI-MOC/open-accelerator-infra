DIAGRAM_SRC = network-diagram.puml
DIAGRAM_SVG = $(DIAGRAM_SRC:.puml=.svg)
DIAGRAM_PNG = $(DIAGRAM_SRC:.puml=.png)

MD_DOCS = vpn-access.md
HTML_DOCS = $(MD_DOCS:.md=.html)


%.svg: %.puml
	plantuml --svg $<

%.png: %.puml
	plantuml --png $<

%.html: %.md
	pandoc -f gfm  --standalone -o "$@" --css style.css "$<" refresh.md

all: $(DIAGRAM_PNG) $(HTML_DOCS)

vpn-access.html: vpn-access.md style.css

clean:
	rm -f $(DIAGRAM_SVG) $(DIAGRAM_PNG) $(HTML_DOCS)
