yubishell ()
{
    ( gpg-connect-agent --quiet updatestartuptty /bye;
    export GPG_TTY=$(tty);
    export SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh";
    export PS1="\[\e[31m\][YUBI]\[\e[0m\] \$ ";
    if which kr > /dev/null 2>&1; then
        kr unpair;
    fi;
    bash --norc )
}