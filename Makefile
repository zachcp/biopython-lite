TAG   = 180
BUILD = 0

download: biopython-biopython-$(TAG)


biopython-biopython-$(TAG): 
	wget https://github.com/biopython/biopython/archive/refs/tags/biopython-$(TAG).tar.gz
	tar -xvf biopython-$(TAG).tar.gz
	rm *tar.gz


numpy: biopython-biopython-$(TAG)
	rg -c numpy biopython-biopython-$(TAG)


dirsize: biopython-biopython-$(TAG)
	du -h -d 1 biopython-biopython-$(TAG)
	du -h -d 1 biopython-biopython-$(TAG)/Bio
	

# Remove the biggest Sources of data and potential numpy-heavy modules.
# we will replace the base setup.py with a modified setup that avoids these issues.
#
trim: biopython-biopython-$(TAG)
	rm -rf biopython-biopython-$(TAG)/Tests/
	rm -rf biopython-biopython-$(TAG)/Doc/
	# Entrez; large
	# PDB / Align: numpy and/or C-extensions
	# Nexus: C-extentions
	rm -rf biopython-biopython-$(TAG)/Bio/Entrez/
	rm -rf biopython-biopython-$(TAG)/Bio/PDB/
	rm -rf biopython-biopython-$(TAG)/Bio/Align/


build: trim
	cp biopython-biopython-$(TAG)/setup.py biopython-biopython-$(TAG)/setup.py_bak
	cp biopython-biopython-$(TAG)/MANIFEST.in biopython-biopython-$(TAG)/MANIFEST.in_bak
	cp resources/setup.py biopython-biopython-$(TAG)/setup.py
	cp resources/MANIFEST.in biopython-biopython-$(TAG)/MANIFEST.in
	cd biopython-biopython-$(TAG) && pyodide build .


biopython-pyodide-$(TAG)-$(BUILD).whl: build
	cp biopython-biopython-$(TAG)/dist/biopython-*-py3-none-any.whl biopython-pyodide-$(TAG)-$(BUILD).whl
	cp biopython-biopython-$(TAG)/dist/biopython-*-py3-none-any.whl biopython-pyodide.whl


wheel: biopython-pyodide-$(TAG)-$(BUILD).whl


clean:
	rm -rf biopython-biopython-$(TAG)
	rm biopython*.tar.gz
	rm biopython-pyodide-$(TAG)-$(BUILD).whl
