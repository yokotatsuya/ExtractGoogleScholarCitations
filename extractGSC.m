function [T,A,J,C,name] = extractGSC(user_id)
% If the url is "https://scholar.google.com/citations?user=ULYa42YAAAAJ&hl=en",
% then user_id = 'ULYa42YAAAAJ'
%
% T : titles
% A : author list
% J : name of journal or conference
% C : number of citation
%
% You need "text analytics toolbox"
% This code was written by Tatsuya Yokota (2020.7.3)


T = [];
A = [];
J = [];
C = [];

for k = 1:100

    code=webread(['https://scholar.google.com/citations?hl=en&user=' user_id '&cstart=' num2str((k-1)*100) '&pagesize=100']);
    tree = htmlTree(code);
    subtrees = findElement(tree,'title,a,div');
    str = extractHTMLText(subtrees);

    % extract author name
    full_name   = erase(str(1),' - Google Scholar Citations');
    spl = split(full_name);
    name = [];
    for n = 1:(length(spl)-1)
        name = [name upper(spl{n}(1))];
    end
    name = [name ' ' spl{end}];
    
    spl2 = split(full_name);
    spl2 = spl(end:-1:1);
    name2 = [];
    for n = 1:(length(spl2)-1)
        name2 = [name2 upper(spl2{n}(1))];
    end
    name2 = [name2 ' ' spl2{end}];

    trigger1 = "Cited by";
    trigger2 = "Cited by";
    trigger3 = "Year";

    % extract papers
    for n = 3:length(str)
        if strcmp(str(n-2),trigger1) & strcmp(str(n-1),trigger2) & strcmp(str(n),trigger3)
            break;
        end
    end

    str(1:n) = [];
    str(end-9:end) = [];
    str(strcmp(str,"*")) = [];

    titles   = str(1:4:end);
    authors  = str(2:4:end);
    journals = str(3:4:end);
    cites    = str(4:4:end);

    T = [T; titles];
    A = [A; authors];
    J = [J; journals];
    C = [C; cites]; 
    
    if length(titles) < 100
        break;
    end

end

C = str2double(C);
C(isnan(C)==1) = 0;

end

