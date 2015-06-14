{-# LANGUAGE OverloadedStrings #-}

import           Network.HaskellNet.IMAP.SSL
import           Network.HaskellNet.Auth (AuthType(LOGIN))


imapServer = "imap.gmail.com"
username = "username@gmail.com"
password = "password"

config = defaultSettingsIMAPSSL { sslMaxLineLength = 100000 }

unseenMessages connection mailBox = do
    select connection mailBox
    msgs <- search connection [NOTs $ FLAG Seen]
    return (length msgs)

main = do
    connection <- connectIMAPSSLWithSettings imapServer config
    login connection username password

    newInbox <- unseenMessages connection "Inbox"
    newSpam <- unseenMessages connection "[Gmail]/Spam"
    putStrLn $ (show newInbox) ++ "/" ++ (show newSpam)
