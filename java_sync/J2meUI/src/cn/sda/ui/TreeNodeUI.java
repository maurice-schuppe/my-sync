package cn.sda.ui;

import java.util.Vector;
import javax.microedition.lcdui.Image;

/**
 *
 * @author Administrator
 */
public class TreeNodeUI {

    private Image image = null;
    private Image selectedImage = null;
    private String nodeString = "";
    //子级组件
    private Vector childsList = null;
    //是否打开
    private boolean expand = false;
    //父级
    private TreeNodeUI parentTreeNode = null;
    //绝对索引
    private int absIndex = -1;
    //层次
    private int layerIndex = -1;
    //在本层的index
    private int index = -1;
    //所属tree
    private TreeViewUI tree = null;

    public Image getImage() {
        return image;
    }

    public void setImage(Image image) {
        this.image = image;
    }

    public void setImage(Image image, Image selectedImage) {
        setImage(image);
        setSelectedImage(selectedImage);
    }

    public Image getSelectedImage() {
        return selectedImage;
    }

    public void setSelectedImage(Image selectedImage) {
        this.selectedImage = selectedImage;
    }

    public String getNodeString() {
        return nodeString;
    }

    public void setNodeString(String nodeString) {
        this.nodeString = nodeString;
    }

    public boolean isExpand() {
        return expand;
    }

    public void setExpand(boolean expand) {
        this.expand = expand;
    }

    public TreeNodeUI getParent() {
        return parentTreeNode;
    }

    protected void setParent(TreeNodeUI parentTreeNode) {
        this.parentTreeNode = parentTreeNode;
    }

    public int getAbsIndex() {
        return absIndex;
    }

    protected void setAbsIndex(int absIndex) {
        this.absIndex = absIndex;
    }

    public int getIndex() {
        return index;
    }

    protected void setIndex(int index) {
        this.index = index;
    }

    public int getLayerIndex() {
        return layerIndex;
    }

    protected void setLayerIndex(int layerIndex) {
        this.layerIndex = layerIndex;
    }

    protected void setTree(TreeViewUI tree) {
        this.tree = tree;
    }

    //判断是否有下一级别
    public boolean hasChild() {
        boolean result = true;
        if (childsList == null || childsList.size() == 0) {
            result = false;
        }
        return result;
    }
    //是否存在指定Node
    public boolean hasChild(TreeNodeUI node) {
        boolean result = false;
        if (childsList == null || childsList.size() == 0) {
            result = false;
        } else {
            if (childsList.contains(node)) {
                result = true;
            }
        }
        return result;
    }

    public boolean hasParent() {
        boolean result = false;
        if (parentTreeNode != null) {
            result = true;
        }
        return result;
    }

    private void createList() {
        if (childsList == null) {
            childsList = new Vector();
        }
    }
    //子集处理
    public TreeNodeUI addChild() {
        TreeNodeUI node = new TreeNodeUI();
        createList();
        childsList.addElement(node);
        node.setParent(this);
        if (tree != null) {
            tree.setTreeNodesIndex();
        }
        return node;
    }

    public TreeNodeUI addChild(String nodeString, Image nodeImage, Image selectNodeImage) {
        TreeNodeUI node = new TreeNodeUI();
        node.nodeString = nodeString;
        node.image = nodeImage;
        node.selectedImage = selectNodeImage;
        createList();
        childsList.addElement(node);
        node.setParent(this);
        if (tree != null) {
            tree.setTreeNodesIndex();
        }
        return node;
    }

    public TreeNodeUI addChild(String nodeString) {
        TreeNodeUI node = new TreeNodeUI();
        node.nodeString = nodeString;
        createList();
        childsList.addElement(node);
        node.setParent(this);
        if (tree != null) {
            tree.setTreeNodesIndex();
        }
        return node;
    }

    public void addChild(TreeNodeUI treeNode) {
        createList();
        if (!childsList.contains(treeNode)) {
            childsList.addElement(treeNode);
            treeNode.setParent(this);
            if (tree != null) {
                tree.setTreeNodesIndex();
            }
        }
    }

    public int getChildsCount() {
        int result = 0;
        if (hasChild()) {
            result = childsList.size();
        }
        return result;
    }

    public TreeNodeUI getChild(int index) {
        TreeNodeUI result = null;
        if (hasChild()) {
            if (index > -1 && index < childsList.size()) {
                result = (TreeNodeUI) childsList.elementAt(index);
            }
        }
        return result;
    }

    public void removeChild(int index) {
        if (hasChild()) {
            if (index > -1 && index < childsList.size()) {
                TreeNodeUI node = (TreeNodeUI) childsList.elementAt(index);
                node.removeAllChild();
                childsList.removeElementAt(index);
                if (tree != null) {
                    tree.setTreeNodesIndex();
                }
            }
        }
    }

    public void removeChild(TreeNodeUI treeNode) {
        if (hasChild()) {
            if (childsList.contains(treeNode)) {
                childsList.removeElement(treeNode);
                treeNode.removeAllChild();
                if (tree != null) {
                    tree.setTreeNodesIndex();
                }
            }
        }
    }

    public void removeAllChild() {
        if (hasChild()) {
            TreeNodeUI node = null;
            for (int i = 0; i < childsList.size(); i++) {
                node = (TreeNodeUI) childsList.elementAt(i);
                node.removeAllChild();
                childsList.removeElementAt(i);
                if (tree != null) {
                    tree.setTreeNodesIndex();
                }
            }
        }
    }
}
