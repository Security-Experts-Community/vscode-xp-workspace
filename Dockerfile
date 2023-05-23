# VSCode XP Web: VSCode XP Web Environment Dockerfile
# Author: Anton Kutepov (@aw350m33d)
# License: MIT

FROM --platform=linux/amd64 codercom/code-server:4.12.0-debian

LABEL maintainer="Anton Kutepov (@aw350m33d)"
LABEL description="Dockerfile for XP web workspace."

ARG NB_USER
ENV NB_USER coder
ENV HOME /home/${NB_USER}
ENV PATH "$HOME/.local/bin:$PATH"
ENV USER_SETTINGS $HOME/.local/share/code-server/User

USER ${NB_USER}
WORKDIR ${HOME}

RUN sudo apt-get update && \
	sudo apt-get install -y \
		curl \
		python3 \
		python3-pip \
		git \
		unzip \
		wget && \
	pip3 install --upgrade pip && \
	wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
	sudo dpkg -i packages-microsoft-prod.deb && \
	rm packages-microsoft-prod.deb && \
	sudo apt-get update && \
	sudo apt-get install -y dotnet-sdk-6.0 && \
	sudo chown -R ${NB_USER}:${NB_USER} ${HOME} && \
	wget https://github.com/vxcontrol/xp-kbt/releases/download/26.0.4358/kbt.26.0.4358-debian.zip -O xp-kbt.zip && \
	unzip xp-kbt.zip -d xp-kbt && \
	rm xp-kbt.zip && \
	git clone https://github.com/Security-Experts-Community/open-xp-rules.git && \
	mkdir -p ${USER_SETTINGS} && \
        printf "{\n    \"xpConfig.kbtBaseDirectory\": \"${HOME}/xp-kbt\",\n    \"cSpell.language\": \"en,ru\"\n}" > ${USER_SETTINGS}/settings.json && \
	mkdir -p ./open-xp-rules/.vscode && \
	mkdir /tmp/vscode-xp && \
	printf "{\n    \"xpConfig.outputDirectoryPath\": \"/tmp/vscode-xp\"\n}" > ./open-xp-rules/.vscode/settings.json && \
	code-server --install-extension SecurityExpertsCommunity.xp && \
	code-server --install-extension streetsidesoftware.code-spell-checker-russian && \
	code-server --install-extension MS-CEINTL.vscode-language-pack-ru
