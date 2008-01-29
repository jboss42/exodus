unit GroupInfo;

interface


type
   TGroupInfo = class
   private
       _name: WideString;
       _expanded: Boolean;
   public
       property Name: WideString read _name write _name;
       property Expanded: Boolean read _expanded write _expanded;
   end; 

implementation

end.
