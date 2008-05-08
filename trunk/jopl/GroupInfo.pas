unit GroupInfo;

interface


type
   TGroupInfo = class
   private
       _Name: WideString;
       _Expanded: Boolean;
   public
       property Name: WideString read _Name write _Name;
       property Expanded: Boolean read _Expanded write _Expanded;
   end; 

implementation

end.
