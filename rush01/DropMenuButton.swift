
import UIKit

class DropMenuButton: UIButton, UITableViewDelegate, UITableViewDataSource
{
    var items = [String]()
    var table = UITableView()
    var act = [() -> (Void)]()
    
    var superSuperView = UIView()
    
    func showItems()
    {
        
        fixLayout()
        
        if(table.alpha == 0)
        {
            self.layer.zPosition = 1
            UIView.animate(withDuration: 0.3
                , animations: {
                    self.table.alpha = 1;
            })
            
        }
            
        else
        {
            
            UIView.animate(withDuration: 0.3
                , animations: {
                    self.table.alpha = 0;
                    self.layer.zPosition = 0
            })
            
        }
        
    }
    
    
    func initMenu(_ items: [String], actions: [() -> (Void)])
    {
        self.items = items
        self.act = actions
        
        var resp = self as UIResponder
        
        while !(resp.isKind(of: UIViewController.self) || (resp.isKind(of: UITableViewCell.self))) && resp.next != nil
        {
            resp = resp.next!
        }
        
        if let vc = resp as? UIViewController{
            superSuperView = vc.view
        }
        else if let vc = resp as? UITableViewCell{
            superSuperView = vc
        }
        
        table = UITableView()
        table.rowHeight = self.frame.height
        table.delegate = self
        table.dataSource = self
        table.isUserInteractionEnabled = true
        table.alpha = 0
        table.separatorColor = self.backgroundColor
        superSuperView.addSubview(table)
        self.addTarget(self, action:#selector(DropMenuButton.showItems), for: .touchUpInside)
        
        //table.registerNib(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "cell")
        
    }
    
    func initMenu(_ items: [String])
    {
        self.items = items
        
        var resp = self as UIResponder
        
        while !(resp.isKind(of: UIViewController.self) || (resp.isKind(of: UITableViewCell.self))) && resp.next != nil
        {
            resp = resp.next!
            
        }
        
        if let vc = resp as? UIViewController{
            
            superSuperView = vc.view
        }
        else if let vc = resp as? UITableViewCell{
            superSuperView = vc
        }
        
        table = UITableView()
        table.rowHeight = self.frame.height
        table.delegate = self
        table.dataSource = self
        table.isUserInteractionEnabled = true
        table.alpha = 0
        table.separatorColor = self.backgroundColor
        superSuperView.addSubview(table)
        self.addTarget(self, action:#selector(DropMenuButton.showItems), for: .touchUpInside)
        
        //table.registerNib(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "cell")
        
    }
    
    
    func fixLayout()
    {
        
        let auxPoint2 = superSuperView.convert(self.frame.origin, from: self.superview)
        
        var tableFrameHeight = CGFloat()
        
        if (items.count >= 3){
            tableFrameHeight = self.frame.height * 3
        }else{
            
            tableFrameHeight = self.frame.height * CGFloat(items.count)
        }
        table.frame = CGRect(x: auxPoint2.x, y: auxPoint2.y + self.frame.height, width: self.frame.width, height:tableFrameHeight)
        table.rowHeight = self.frame.height
        
        table.reloadData()
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setNeedsDisplay()
        fixLayout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.setBackgroundImage(UIImage(named: items[indexPath.row]), for: UIControlState())
        self.setBackgroundImage(UIImage(named: items[indexPath.row]), for: UIControlState.highlighted)
        self.setBackgroundImage(UIImage(named: items[indexPath.row]), for: UIControlState.selected)

        if self.act.count > 1
        {
            self.act[indexPath.row]()
        }
        showItems()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        tableView.backgroundColor = nil
        let itemLabel = UILabel(frame: CGRect(x: 2, y: 2, width: self.frame.width, height: self.frame.height))
        itemLabel.backgroundColor = UIColor(patternImage: UIImage(named: items[(indexPath as NSIndexPath).row])!)
        itemLabel.contentMode = .scaleAspectFit
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        
        cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        cell.separatorInset = UIEdgeInsetsMake(0, self.frame.width, 0, self.frame.width)
        
        cell.addSubview(itemLabel)
        
        return cell
    }
    
}
