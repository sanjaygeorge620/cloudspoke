public with sharing class LX_SLDBReportControlr {
public Boolean rList{get;set;}
public Boolean DB{get;set;}
public Boolean LS{get;set;}
public Boolean LI{get;set;}
public Boolean GA{get;set;}
 public LX_SLDBReportControlr(){
  rList=true;
  DB=false; 
  LS=false; 
  LI=false; 
  GA=false; 
 }
 public void Dashbrd(){
  rList=false;
  DB=true;
  LS=false; 
  LI=false; 
  GA=false; 
 }
 public void LoySumm(){
  rList=false;
  DB=false;
  LS=true; 
  LI=false; 
  GA=false;
 }
 public void LoyInfo(){
  rList=false;
  DB=false;
  LS=false; 
  LI=true; 
  GA=false;
 }
 public void GapAnaly(){
  rList=false;
  DB=false;
  LS=false; 
  LI=false; 
  GA=true;
 }
 public void Back(){
  rList=true;
  DB=false;
  LS=false; 
  LI=false; 
  GA=false; 
 }
}