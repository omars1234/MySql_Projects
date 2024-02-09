import pymysql.connections
import streamlit as st


mydb=pymysql.connect(
    host="localhost",
    user="root",
    password="1691983Omar@_sql",
    database="customer_2")

mycursor=mydb.cursor()
print("connect established")


def main():
    st.title("customer_2 operations with mysql");

    option=st.sidebar.selectbox("select and operation",("Create","Read","Update","Delete"))
    if option=="Create":
        st.subheader("Create a Recored")
        firstname=st.text_input("Enter firstname")
        lastname=st.text_input("Enter lastname")
        country=st.text_input("Enter Country")
        if st.button("Create"):
            sql="insert into customer_details(firstname,lastname,country) values(%s,%s,%s)"
            val=(firstname,lastname,country)
            mycursor.execute(sql,val)
            mydb.commit()
            st.success("Record Created Succssfuly")
      


    elif option=="Read":
        st.subheader("Read Recored")
        mycursor.execute("select * from customer_details")
        result =mycursor.fetchall()
        for row in result:
            st.write(row)


    elif option=="Update":
        st.subheader("Update a Recored")
        id=st.number_input("Enter ID")
        firstname=st.text_input("Enter New firstname")
        lastname=st.text_input("Enter New lastname")
        country=st.text_input("Enter New Country")
        if st.button("Update"):
            sql="update customer_details set firstname=%s, lastname=%s, country=%s where id=%s"
            val=(firstname,lastname,country,id)
            mycursor.execute(sql,val)
            mydb.commit()
            st.success("Record Updated Successfuly")


    elif option=="Delete":
        st.subheader("Delete Recored")
        id=st.number_input("Enter ID to delete record")
        if st.button("Delete"):
            sql="delete from customer_details where id=%s"
            val=(id,)
            mycursor.execute(sql,val)
            mydb.commit()
            st.success("Record deleted Successfuly")










if __name__=="__main__":
    main()
    

     


