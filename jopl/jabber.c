#include "config.h"
#include "stringprep.h"

/**
#define stringprep_xmpp_nodeprep(in, maxlen)		\
  stringprep(in, maxlen, 0, stringprep_xmpp_nodeprep)
#define stringprep_xmpp_resourceprep(in, maxlen)		\
  stringprep(in, maxlen, 0, stringprep_xmpp_resourceprep)
**/

char* jabber_nodeprep(const char* input)
{
    // just use a max size buffer here
    char buff[1024];
    
    // copy the input into the buffer
    strcpy(buff, input);

    // stringprep, dup, and return
    if (stringprep_xmpp_nodeprep(buff, 1024) == STRINGPREP_OK) 
    {
        return strdup(&buff);            
    }
    else
    {
        return NULL;
    }
}

char* jabber_nameprep(const char* input)
{
    // just use a max size buffer here
    char buff[1024];
    
    // copy the input into the buffer
    strcpy(buff, input);

    // stringprep, dup, and return
    if (stringprep_nameprep(buff, 1024) == STRINGPREP_OK)
    {      
        return strdup(&buff);            
    }
    else
    {
        return NULL;
    }
    
}

char* jabber_resourceprep(const char* input)
{
    // just use a max size buffer here
    char buff[1024];
    
    // copy the input into the buffer
    strcpy(buff, input);

    // stringprep, dup, and return
    if (stringprep_xmpp_resourceprep(buff, 1024) == STRINGPREP_OK)
    {
        return strdup(&buff);            
    }
    else
    {
        return NULL;
    }
}
