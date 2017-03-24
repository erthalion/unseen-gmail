{-# LANGUAGE OverloadedStrings #-}

import           Control.Exception
import           System.IO
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

withEcho echo action = do
  old <- hGetEcho stdin
  bracket_ (hSetEcho stdin echo) (hSetEcho stdin old) action

main = do
    password <- withEcho False getLine
    connection <- connectIMAPSSLWithSettings imapServer config
    login connection username password

    newInbox <- unseenMessages connection "Inbox"
    newSpam <- unseenMessages connection "[Gmail]/Spam"
    newPG <- unseenMessages connection "pgsql-important"
    putStrLn $ (show newInbox) ++ "/" ++ (show newSpam) ++ "/" ++ (show newPG)
