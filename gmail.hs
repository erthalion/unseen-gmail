{-# LANGUAGE OverloadedStrings #-}

import           Network.HaskellNet.IMAP.SSL
import           Network.HaskellNet.Auth (AuthType(LOGIN))


imapServer = "imap.gmail.com"
username = "username@gmail.com"
password = "password"

config = defaultSettingsIMAPSSL { sslMaxLineLength = 100000 }

unseenMessages mailBox = do
    connection <- connectIMAPSSLWithSettings imapServer config
    login connection username password
    select connection mailBox
    msgs <- search connection [NOTs $ FLAG Seen]
    return (length msgs)

main = do
    newInbox <- unseenMessages "Inbox"
    newSpam <- unseenMessages "[Gmail]/Spam"
    putStrLn $ (show newInbox) ++ "/" ++ (show newSpam)
